import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../models/game_state.dart';
import '../painters/game_painter.dart';
import '../services/game_service.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/menu_overlay.dart';
import '../widgets/score_display.dart';

/// The main game screen: wires up the game loop, input and overlays.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final GameService _game = GameService();
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // ---- Game loop tick ----
  void _onTick(Duration elapsed) {
    if (!_initialized) {
      _lastTick = elapsed;
      return;
    }
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _game.update(dt);
    setState(() {});
  }

  // ---- Input handling ----
  void _handleTap() {
    switch (_game.state) {
      case GameState.menu:
        _game.startGame();
      case GameState.playing:
        _game.jump();
      case GameState.gameOver:
        break; // handled by overlay buttons
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _handleTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ---- Build ----
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          if (!_initialized) {
            _game.initialize(size);
            _initialized = true;
          }

          return DefaultTextStyle(
            style: const TextStyle(decoration: TextDecoration.none),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) => _handleTap(),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Game canvas
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: GamePainter(_game),
                      size: size,
                    ),
                  ),

                  // HUD during gameplay
                  if (_game.state == GameState.playing) ...[
                    ScoreDisplay(score: _game.score),
                    _buildHomeButton(),
                  ],

                  // Menu overlay
                  if (_game.state == GameState.menu)
                    MenuOverlay(highScore: _game.highScore),

                  // Game Over overlay (handles its own taps)
                  if (_game.state == GameState.gameOver)
                    GameOverOverlay(
                      score: _game.score,
                      highScore: _game.highScore,
                      canRestart: _game.canRestart,
                      onRestart: () {
                        if (_game.canRestart) _game.startGame();
                      },
                      onMenu: () => _game.goToMenu(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Small home button in the top-left corner during gameplay.
  Widget _buildHomeButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 12,
      child: GestureDetector(
        onTap: () => _game.goToMenu(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x66000000),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.home_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
