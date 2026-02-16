import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/game_state.dart';
import '../services/game_controller.dart';
import '../widgets/game_canvas.dart';
import '../widgets/score_display.dart';

/// The main game play screen with physics rendering loop.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late GameController _controller;
  Duration _previousTime = Duration.zero;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!_initialized) return;

    final dt = (elapsed - _previousTime).inMicroseconds / 1000000.0;
    _previousTime = elapsed;

    _controller.update(dt);
    setState(() {});
  }

  void _initializeGame(Size size) {
    if (!_initialized) {
      _controller.initialize(size);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initializeGame(size);

          return GestureDetector(
            onPanStart: (details) {
              _controller.onDragStart(details.localPosition);
            },
            onPanUpdate: (details) {
              _controller.onDragUpdate(details.localPosition);
            },
            onPanEnd: (_) {
              _controller.onDragEnd();
            },
            onTapUp: (details) {
              _controller.onTap(details.localPosition);
            },
            child: Stack(
              children: [
                // Game canvas
                RepaintBoundary(
                  child: CustomPaint(
                    size: size,
                    painter: GameCanvasPainter(
                      ball: _controller.ball,
                      obstacles: _controller.obstacles,
                      dragLine: _controller.dragLine,
                      score: _controller.state.score,
                      showReady:
                          _controller.state.status == GameStatus.ready,
                    ),
                  ),
                ),

                // Score overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ScoreDisplay(
                    score: _controller.state.score,
                    highScore: _controller.state.highScore,
                    bounces: _controller.state.totalBounces,
                  ),
                ),

                // Control buttons
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildControlButton(
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_controller.state.status ==
                                    GameStatus.playing ||
                                _controller.state.status ==
                                    GameStatus.paused)
                              _buildControlButton(
                                icon: _controller.state.status ==
                                        GameStatus.paused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                onPressed: () {
                                  _controller.togglePause();
                                  setState(() {});
                                },
                              ),
                            const SizedBox(width: 12),
                            _buildControlButton(
                              icon: Icons.refresh_rounded,
                              onPressed: () {
                                _controller.restartGame();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Paused overlay
                if (_controller.state.status == GameStatus.paused)
                  IgnorePointer(
                    child: _buildPausedOverlay(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Icon(icon, color: Colors.white70, size: 24),
        ),
      ),
    );
  }

  Widget _buildPausedOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pause_circle_outline,
              color: Colors.white70,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap play to continue',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
