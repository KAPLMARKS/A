import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../models/game_state.dart';
import '../models/chicken.dart';
import '../models/feather.dart';
import '../models/score_popup.dart';
import '../painters/river_painter.dart';
import '../services/logger.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/hud_widget.dart';
import '../widgets/combo_widget.dart';
import '../widgets/wave_announcement.dart';
import '../widgets/overlays/menu_overlay.dart';
import '../widgets/overlays/pause_overlay.dart';
import '../widgets/overlays/game_over_overlay.dart';
import '../widgets/overlays/tutorial_overlay.dart';

/// Root game screen that hosts the game loop and all sub-views.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _tag = 'GameScreen';

  // ── State ──────────────────────────────────────────────────
  GameState _state = GameState.menu;
  int _score = 0;
  int _lives = GameConstants.startLives;
  int _combo = 0;
  int _maxCombo = 0;
  double _comboTimer = 0;
  int _wave = 1;
  double _waveTimer = 0;
  double _waveAnnTimer = 0;
  bool _freezeActive = false;
  double _freezeTimer = 0;
  double _flashTimer = 0;
  Color _flashColor = Colors.transparent;
  int _poppedCount = 0;
  bool _showTutorial = false;
  bool _isNewRecord = false;

  // ── Persisted stats ────────────────────────────────────────
  int _highScore = 0;
  int _bestWave = 0;
  int _bestCombo = 0;
  int _totalPops = 0;
  int _gamesPlayed = 0;
  bool _tutorialSeen = false;

  // ── Timers ─────────────────────────────────────────────────
  double _gameTime = 0;
  double _spawnTimer = 0;

  // ── Entities ───────────────────────────────────────────────
  final List<Chicken> _chickens = [];
  final List<Feather> _feathers = [];
  final List<ScorePopup> _popups = [];

  // ── Engine ─────────────────────────────────────────────────
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final Random _rng = Random();

  // ── Layout cache ───────────────────────────────────────────
  double _w = 0, _h = 0, _topPad = 0;

  // ── Services ───────────────────────────────────────────────
  final StorageService _storage = StorageService();

  // ─────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = createTicker(_tick);
    _initStorage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ticker.isActive) _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _state == GameState.playing) {
      _pauseGame();
    }
  }

  Future<void> _initStorage() async {
    try {
      await _storage.init();
      if (!mounted) return;
      setState(() {
        _highScore = _storage.highScore;
        _bestWave = _storage.bestWave;
        _bestCombo = _storage.bestCombo;
        _totalPops = _storage.totalPops;
        _gamesPlayed = _storage.gamesPlayed;
        _tutorialSeen = _storage.tutorialSeen;
      });
      Log.info(_tag, 'Stats loaded — high=$_highScore wave=$_bestWave');
    } catch (e, s) {
      Log.error(_tag, 'Failed to load stats', e, s);
    }
  }

  // ─────────────────────────────────────────────────────────
  // Game flow
  // ─────────────────────────────────────────────────────────

  void _startGame() {
    if (_ticker.isActive) _ticker.stop();
    _state = GameState.playing;
    _score = 0;
    _lives = GameConstants.startLives;
    _combo = 0;
    _maxCombo = 0;
    _comboTimer = 0;
    _wave = 1;
    _waveTimer = 0;
    _waveAnnTimer = 2.0;
    _freezeActive = false;
    _freezeTimer = 0;
    _flashTimer = 0;
    _poppedCount = 0;
    _isNewRecord = false;
    _gameTime = 0;
    _spawnTimer = 0;
    _showTutorial = false;
    _chickens.clear();
    _feathers.clear();
    _popups.clear();
    _lastElapsed = Duration.zero;
    setState(() {});
    _ticker.start();
    Log.info(_tag, 'Game started');
  }

  void _onPlayPressed() {
    if (!_tutorialSeen) {
      _tutorialSeen = true;
      setState(() => _showTutorial = true);
    } else {
      _startGame();
    }
  }

  void _pauseGame() {
    if (_ticker.isActive) _ticker.stop();
    setState(() => _state = GameState.paused);
  }

  void _resumeGame() {
    _state = GameState.playing;
    _lastElapsed = Duration.zero;
    setState(() {});
    _ticker.start();
  }

  void _gameOver() {
    if (_ticker.isActive) _ticker.stop();
    _gamesPlayed++;
    _totalPops += _poppedCount;
    _isNewRecord = _score > _highScore;
    if (_score > _highScore) _highScore = _score;
    if (_wave > _bestWave) _bestWave = _wave;
    if (_maxCombo > _bestCombo) _bestCombo = _maxCombo;

    _storage.saveGameResult(
      highScore: _highScore,
      bestWave: _bestWave,
      bestCombo: _bestCombo,
      totalPops: _totalPops,
      gamesPlayed: _gamesPlayed,
    );

    setState(() => _state = GameState.gameOver);
    Log.info(_tag, 'Game over — score=$_score wave=$_wave');
  }

  void _toMenu() {
    if (_ticker.isActive) _ticker.stop();
    setState(() {
      _state = GameState.menu;
      _showTutorial = false;
    });
  }

  // ─────────────────────────────────────────────────────────
  // Game loop
  // ─────────────────────────────────────────────────────────

  void _tick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.1) return;

    _gameTime += dt;

    // Wave progression
    _waveTimer += dt;
    if (_waveTimer >= GameConstants.waveDuration) {
      _waveTimer -= GameConstants.waveDuration;
      _wave++;
      _waveAnnTimer = 2.0;
    }
    if (_waveAnnTimer > 0) _waveAnnTimer -= dt;

    // Spawning
    final spawnInterval = max(
      GameConstants.minSpawnInterval,
      GameConstants.baseSpawnInterval -
          (_wave - 1) * GameConstants.spawnIntervalWaveReduction -
          _gameTime * GameConstants.spawnIntervalTimeReduction,
    );

    if (_gameTime > GameConstants.spawnDelay) {
      _spawnTimer += dt;
      while (_spawnTimer >= spawnInterval) {
        _spawnTimer -= spawnInterval;
        _spawn();
      }
    }

    // Combo decay
    if (_combo > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _combo = 0;
    }

    // Freeze decay
    if (_freezeActive) {
      _freezeTimer -= dt;
      if (_freezeTimer <= 0) _freezeActive = false;
    }

    // Flash decay
    if (_flashTimer > 0) _flashTimer -= dt * 3;

    // Move entities
    final speedMod = _freezeActive ? 0.3 : 1.0;
    for (final c in _chickens) {
      if (!c.isPopped) {
        c.x += c.speed * c.direction * dt * speedMod;
        c.y = c.baseY + sin(_gameTime * c.freq + c.wobble) * c.amplitude;
      }
    }

    // Update feathers
    for (final f in _feathers) {
      f.x += f.vx * dt;
      f.y += f.vy * dt;
      f.vy += GameConstants.featherGravity * dt;
      f.life -= dt * GameConstants.featherDecay;
      f.rotation += f.rotSpeed * dt;
    }
    _feathers.removeWhere((f) => f.life <= 0);

    // Remove old popups
    _popups.removeWhere(
        (p) => _gameTime - p.spawnTime > GameConstants.popupDuration);

    // Check escaped / finished chickens
    final escaped = <Chicken>[];
    final done = <Chicken>[];
    for (final c in _chickens) {
      if (c.isPopped) {
        if (_gameTime - c.poppedAt > GameConstants.popDuration) done.add(c);
      } else if ((c.direction > 0 && c.x > _w + c.size) ||
          (c.direction < 0 && c.x < -c.size * 1.5)) {
        escaped.add(c);
      }
    }
    for (final c in escaped) {
      _chickens.remove(c);
      if (c.isBird) {
        _lives--;
        _combo = 0;
        if (_lives <= 0) {
          _gameOver();
          return;
        }
      }
    }
    _chickens.removeWhere((c) => done.contains(c));

    setState(() {});
  }

  // ─────────────────────────────────────────────────────────
  // Spawning
  // ─────────────────────────────────────────────────────────

  void _spawn() {
    if (_w == 0 || _h == 0) return;

    final roll = _rng.nextDouble() * 100;
    ChickenType type;

    if (_wave >= 5 && roll < 3) {
      type = ChickenType.heart;
    } else if (_wave >= 5 && roll < 6) {
      type = ChickenType.freeze;
    } else if (_wave >= 4 && roll < 14) {
      type = ChickenType.bomb;
    } else if (_wave >= 3 && roll < 22) {
      type = ChickenType.golden;
    } else {
      type = _randomRegular();
    }

    _spawnOfType(type);
  }

  ChickenType _randomRegular() {
    final types = [ChickenType.normal];
    if (_wave >= 2) types.addAll([ChickenType.small, ChickenType.big]);
    if (_wave >= 3) types.addAll([ChickenType.duck, ChickenType.baby]);
    return types[_rng.nextInt(types.length)];
  }

  void _spawnOfType(ChickenType type) {
    late String emoji;
    late double speed, size;
    late int points;
    double amp = 4.0, freq = 6.0;

    switch (type) {
      case ChickenType.normal:
        emoji = '🐔'; speed = 90; size = 44; points = 1;
      case ChickenType.small:
        emoji = '🐥'; speed = 155; size = 36; points = 2;
      case ChickenType.big:
        emoji = '🐓'; speed = 65; size = 52; points = 3;
      case ChickenType.duck:
        emoji = '🦆'; speed = 115; size = 40; points = 2;
      case ChickenType.baby:
        emoji = '🐤'; speed = 135; size = 34; points = 2;
      case ChickenType.golden:
        emoji = '🌟'; speed = 185; size = 38; points = 10; freq = 10;
      case ChickenType.bomb:
        emoji = '💣'; speed = 75; size = 42; points = 0; amp = 8;
      case ChickenType.heart:
        emoji = '❤️'; speed = 140; size = 34; points = 0; amp = 6;
      case ChickenType.freeze:
        emoji = '❄️'; speed = 130; size = 36; points = 1; amp = 5;
    }

    final dir = _rng.nextBool() ? 1.0 : -1.0;
    final x = dir > 0 ? -size : _w + size * 0.5;
    final yMin = _topPad + 80.0;
    final yMax = _h - 60.0 - size;
    if (yMax <= yMin) return;
    final y = yMin + _rng.nextDouble() * (yMax - yMin);
    final speedMul = 1.0 + _gameTime / 100.0;

    _chickens.add(Chicken(
      x: x,
      y: y,
      speed: speed * speedMul,
      direction: dir,
      size: size,
      emoji: emoji,
      points: points,
      type: type,
      amplitude: amp,
      freq: freq,
    ));
  }

  // ─────────────────────────────────────────────────────────
  // Tap handling
  // ─────────────────────────────────────────────────────────

  void _tapItem(Chicken c) {
    if (c.isPopped || _state != GameState.playing) return;
    c.isPopped = true;
    c.poppedAt = _gameTime;
    _poppedCount++;

    switch (c.type) {
      case ChickenType.bomb:
        _lives--;
        _combo = 0;
        _flash(const Color(0xFFFF0000));
        HapticFeedback.heavyImpact();
        _burstFeathers(c.x + c.size * 0.4, c.y + c.size * 0.4, colors: const [
          Color(0xFFFF6B00),
          Color(0xFFFF0000),
          Color(0xFF757575),
          Color(0xFF212121),
        ]);
        if (_lives <= 0) {
          _gameOver();
          return;
        }
      case ChickenType.heart:
        if (_lives < GameConstants.maxLives) _lives++;
        _flash(const Color(0xFFFF69B4));
        HapticFeedback.mediumImpact();
        _burstFeathers(c.x + c.size * 0.4, c.y + c.size * 0.4, colors: const [
          Color(0xFFFF69B4),
          Color(0xFFFF80AB),
          Colors.white,
        ]);
        _addPopup(c.x, c.y, '+❤️', Colors.pinkAccent);
      case ChickenType.freeze:
        _freezeActive = true;
        _freezeTimer = GameConstants.freezeDuration;
        _flash(const Color(0xFF00BFFF));
        HapticFeedback.mediumImpact();
        _burstFeathers(c.x + c.size * 0.4, c.y + c.size * 0.4, colors: const [
          Color(0xFF81D4FA),
          Color(0xFF00BCD4),
          Colors.white,
        ]);
        _addComboPoints(c);
      default:
        _addComboPoints(c);
        HapticFeedback.lightImpact();
        _burstFeathers(c.x + c.size * 0.4, c.y + c.size * 0.4);
    }
  }

  void _addComboPoints(Chicken c) {
    _combo++;
    _comboTimer = GameConstants.comboDuration;
    if (_combo > _maxCombo) _maxCombo = _combo;
    final mul = min(_combo, GameConstants.maxComboMultiplier);
    final pts = c.points * mul;
    _score += pts;
    _addPopup(
      c.x + c.size * 0.3,
      c.y - 10,
      '+$pts',
      pts >= 10 ? const Color(0xFFFF6D00) : const Color(0xFFFFD600),
    );
  }

  void _addPopup(double x, double y, String text, Color color) {
    _popups.add(ScorePopup(x: x, y: y, text: text, color: color, spawnTime: _gameTime));
  }

  void _flash(Color color) {
    _flashColor = color;
    _flashTimer = 1.0;
  }

  void _burstFeathers(double cx, double cy, {List<Color>? colors}) {
    final c = colors ?? GameConstants.defaultFeatherColors;
    for (int i = 0; i < GameConstants.featherCount; i++) {
      final a = _rng.nextDouble() * pi * 2;
      final spd =
          GameConstants.featherBaseSpeed + _rng.nextDouble() * GameConstants.featherSpeedRange;
      _feathers.add(Feather(
        x: cx,
        y: cy,
        vx: cos(a) * spd,
        vy: sin(a) * spd + GameConstants.featherLaunchVy,
        color: c[_rng.nextInt(c.length)],
        size: 4 + _rng.nextDouble() * 7,
      ));
    }
  }

  String _fmtTime(double t) {
    final m = (t ~/ 60).toString().padLeft(2, '0');
    final s = (t.toInt() % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ─────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    _w = mq.size.width;
    _h = mq.size.height;
    _topPad = mq.padding.top;

    return Scaffold(
      backgroundColor: GameConstants.grassLight,
      body: SizedBox.expand(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // River background
            Positioned.fill(
              child: CustomPaint(
                painter: RiverPainter(gameTime: _gameTime),
                size: Size.infinite,
              ),
            ),

            // Chickens
            for (final c in _chickens) _chickenWidget(c),

            // Feather particles
            for (final f in _feathers) _featherWidget(f),

            // Score popups
            for (final p in _popups) _popupWidget(p),

            // Freeze overlay
            if (_freezeActive)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.lightBlue.withValues(alpha: 0.12),
                  ),
                ),
              ),

            // Flash overlay
            if (_flashTimer > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: _flashColor
                        .withValues(alpha: _flashTimer.clamp(0.0, 1.0) * 0.35),
                  ),
                ),
              ),

            // HUD
            if (_state == GameState.playing)
              HudWidget(
                score: _score,
                wave: _wave,
                lives: _lives,
                onPause: _pauseGame,
              ),

            // Combo
            if (_state == GameState.playing && _combo > 1)
              ComboWidget(combo: _combo, topPad: _topPad),

            // Wave announcement
            if (_state == GameState.playing && _waveAnnTimer > 0)
              WaveAnnouncement(wave: _wave, timer: _waveAnnTimer),

            // Menu
            if (_state == GameState.menu)
              MenuOverlay(
                highScore: _highScore,
                bestWave: _bestWave,
                bestCombo: _bestCombo,
                gamesPlayed: _gamesPlayed,
                totalPops: _totalPops,
                onPlay: _onPlayPressed,
              ),

            // Pause
            if (_state == GameState.paused)
              PauseOverlay(
                score: _score,
                wave: _wave,
                onResume: _resumeGame,
                onQuit: _toMenu,
              ),

            // Game over
            if (_state == GameState.gameOver)
              GameOverOverlay(
                score: _score,
                highScore: _highScore,
                isNewRecord: _isNewRecord,
                wave: _wave,
                poppedCount: _poppedCount,
                maxCombo: _maxCombo,
                formattedTime: _fmtTime(_gameTime),
                onPlayAgain: _startGame,
                onMenu: _toMenu,
              ),

            // Tutorial
            if (_showTutorial)
              TutorialOverlay(onDismiss: () {
                setState(() => _showTutorial = false);
                _startGame();
              }),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Entity widgets
  // ─────────────────────────────────────────────────────────

  Widget _chickenWidget(Chicken c) {
    double scale = 1.0;
    double opacity = 1.0;

    if (c.isPopped) {
      final t = ((_gameTime - c.poppedAt) / GameConstants.popDuration)
          .clamp(0.0, 1.0);
      scale = 1.0 + t * 0.6;
      opacity = (1.0 - t).clamp(0.0, 1.0);
    } else {
      scale = 1.0 + sin(_gameTime * 10 + c.wobble) * 0.04;
    }

    Color? glowColor;
    double glowRadius = 16;
    switch (c.type) {
      case ChickenType.golden:
        glowColor = const Color(0xFFFFD700);
        glowRadius = 20;
      case ChickenType.bomb:
        glowColor = const Color(0xFFFF0000);
        glowRadius = 14 + sin(_gameTime * 8).abs() * 6;
      case ChickenType.heart:
        glowColor = const Color(0xFFFF69B4);
        glowRadius = 16 + sin(_gameTime * 4).abs() * 4;
      case ChickenType.freeze:
        glowColor = const Color(0xFF00BFFF);
      default:
        break;
    }

    Widget content = Text(c.emoji, style: TextStyle(fontSize: c.size));

    if (glowColor != null && !c.isPopped) {
      content = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: glowRadius,
              spreadRadius: 2,
            ),
          ],
        ),
        child: content,
      );
    }

    return Positioned(
      left: c.x,
      top: c.y,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _tapItem(c),
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: SizedBox(
              width: c.size * 1.3,
              height: c.size * 1.3,
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }

  Widget _featherWidget(Feather f) {
    final opacity = f.life.clamp(0.0, 1.0);
    return Positioned(
      left: f.x,
      top: f.y,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: f.rotation,
          child: Container(
            width: f.size,
            height: f.size * 0.55,
            decoration: BoxDecoration(
              color: f.color,
              borderRadius: BorderRadius.circular(f.size),
            ),
          ),
        ),
      ),
    );
  }

  Widget _popupWidget(ScorePopup p) {
    final t = ((_gameTime - p.spawnTime) / GameConstants.popupDuration)
        .clamp(0.0, 1.0);
    return Positioned(
      left: p.x,
      top: p.y - t * 50,
      child: IgnorePointer(
        child: Opacity(
          opacity: (1.0 - t).clamp(0.0, 1.0),
          child: Text(
            p.text,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: p.color,
              shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
            ),
          ),
        ),
      ),
    );
  }
}
