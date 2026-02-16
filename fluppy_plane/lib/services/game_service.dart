import 'dart:math';
import 'dart:ui' show Size;

import '../config/game_config.dart';
import '../models/game_state.dart';
import '../models/plane_model.dart';
import '../models/pipe_model.dart';
import '../utils/app_logger.dart';

/// Core game logic: physics, pipe spawning, collision detection, scoring.
class GameService {
  late GameConfig config;
  late PlaneModel plane;

  final List<PipeModel> pipes = [];
  final Random _random = Random();

  GameState state = GameState.menu;
  int score = 0;
  int highScore = 0;

  double _timeSinceLastPipe = 0.0;
  double _groundScrollOffset = 0.0;
  double _totalTime = 0.0;
  double _menuBobTime = 0.0;
  double _gameOverCooldown = 0.0;

  // ---- Public getters used by the painter ----
  double get groundScrollOffset => _groundScrollOffset;
  double get totalTime => _totalTime;
  bool get canRestart => _gameOverCooldown <= 0;

  /// Initialise (or re‑initialise) with the current screen size.
  void initialize(Size screenSize) {
    config = GameConfig(screenSize);
    plane = PlaneModel(x: config.planeX, y: config.planeStartY);
    AppLogger.info('Game initialised – screen ${screenSize.width}×${screenSize.height}');
  }

  /// Start a new game round.
  void startGame() {
    state = GameState.playing;
    score = 0;
    pipes.clear();
    plane.reset(config.planeX, config.planeStartY);
    plane.velocity = config.jumpVelocity * 0.6;
    _timeSinceLastPipe = config.pipeSpawnInterval * 0.65;
    _gameOverCooldown = 0.0;
    AppLogger.info('Game started');
  }

  /// Return to the main menu.
  void goToMenu() {
    state = GameState.menu;
    score = 0;
    pipes.clear();
    plane.reset(config.planeX, config.planeStartY);
    _menuBobTime = 0.0;
    AppLogger.info('Returned to menu');
  }

  /// Called on player tap during gameplay.
  void jump() {
    if (state == GameState.playing) {
      plane.velocity = config.jumpVelocity;
    }
  }

  // ----------------------------------------------------------------
  // Main update – called every frame
  // ----------------------------------------------------------------
  void update(double dt) {
    dt = dt.clamp(0.0, 0.05);
    if (dt == 0) return;

    _totalTime += dt;

    switch (state) {
      case GameState.menu:
        _updateMenu(dt);
      case GameState.playing:
        _updatePlaying(dt);
      case GameState.gameOver:
        _updateGameOver(dt);
    }
  }

  // ----------------------------------------------------------------
  // State‑specific updates
  // ----------------------------------------------------------------

  void _updateMenu(double dt) {
    _groundScrollOffset += config.pipeSpeed * dt * 0.4;
    _menuBobTime += dt;
    plane.y = config.planeStartY + sin(_menuBobTime * 2.5) * 15.0 * config.scale;
    plane.rotation = sin(_menuBobTime * 2.5) * 0.08;
  }

  void _updatePlaying(double dt) {
    // Ground scrolling
    _groundScrollOffset += config.pipeSpeed * dt;

    // Plane physics
    plane.velocity += config.gravity * dt;
    plane.velocity = plane.velocity.clamp(-config.maxFallSpeed, config.maxFallSpeed);
    plane.y += plane.velocity * dt;

    // Smooth rotation towards velocity direction
    final targetRotation = (plane.velocity / config.maxFallSpeed) * (pi / 3);
    plane.rotation += (targetRotation - plane.rotation) * 0.12;

    // Pipe spawning
    _timeSinceLastPipe += dt;
    if (_timeSinceLastPipe >= config.pipeSpawnInterval) {
      _spawnPipe();
      _timeSinceLastPipe = 0.0;
    }

    // Move pipes & check scoring
    for (final pipe in pipes) {
      pipe.x -= config.pipeSpeed * dt;
      if (!pipe.scored && pipe.rightEdge < plane.x) {
        pipe.scored = true;
        score++;
        AppLogger.info('Score: $score');
      }
    }
    pipes.removeWhere((p) => p.rightEdge < -20);

    // Collision
    if (_checkCollision()) {
      _triggerGameOver();
    }
  }

  void _updateGameOver(double dt) {
    _gameOverCooldown -= dt;

    // Plane falls to ground after crash
    plane.velocity += config.gravity * dt;
    plane.velocity = plane.velocity.clamp(-config.maxFallSpeed, config.maxFallSpeed);
    plane.y += plane.velocity * dt;

    final groundLimit = config.groundY - config.planeHeight / 2;
    if (plane.y >= groundLimit) {
      plane.y = groundLimit;
      plane.velocity = 0.0;
    }

    // Nose‑dive rotation
    final targetRot = pi / 2.5;
    plane.rotation += (targetRot - plane.rotation) * 0.06;
  }

  // ----------------------------------------------------------------
  // Pipe spawning
  // ----------------------------------------------------------------

  void _spawnPipe() {
    final gapCenter = config.pipeMinGapCenter +
        _random.nextDouble() * (config.pipeMaxGapCenter - config.pipeMinGapCenter);

    pipes.add(PipeModel(
      x: config.width + 10,
      gapCenterY: gapCenter,
      gapHeight: config.pipeGapHeight,
      width: config.pipeWidth,
    ));
  }

  // ----------------------------------------------------------------
  // Collision detection (AABB)
  // ----------------------------------------------------------------

  bool _checkCollision() {
    final m = config.hitboxMargin;
    final planeLeft = plane.x - config.planeWidth / 2 + m;
    final planeRight = plane.x + config.planeWidth / 2 - m;
    final planeTop = plane.y - config.planeHeight / 2 + m;
    final planeBottom = plane.y + config.planeHeight / 2 - m;

    // Ground / ceiling
    if (planeBottom >= config.groundY) return true;
    if (planeTop <= 0) return true;

    // Pipes
    for (final pipe in pipes) {
      if (planeRight > pipe.x && planeLeft < pipe.rightEdge) {
        if (planeTop < pipe.topPipeBottom || planeBottom > pipe.bottomPipeTop) {
          return true;
        }
      }
    }
    return false;
  }

  // ----------------------------------------------------------------
  // Game over
  // ----------------------------------------------------------------

  void _triggerGameOver() {
    state = GameState.gameOver;
    _gameOverCooldown = 0.6;
    if (score > highScore) {
      highScore = score;
    }
    AppLogger.info('Game over – score $score, best $highScore');
  }
}
