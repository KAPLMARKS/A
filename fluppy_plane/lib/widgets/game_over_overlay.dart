import 'package:flutter/material.dart';

/// Overlay displayed after a crash.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.canRestart,
    required this.onRestart,
    required this.onMenu,
  });

  final int score;
  final int highScore;
  final bool canRestart;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  bool get _isNewRecord => score > 0 && score >= highScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x55000000),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Color(0x44000000), blurRadius: 16, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE53935),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),

                // Score
                const Text('SCORE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF757575))),
                const SizedBox(height: 4),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF212121)),
                ),
                const SizedBox(height: 12),

                // Best
                const Text('BEST', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF757575))),
                const SizedBox(height: 4),
                Text(
                  '$highScore',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1565C0)),
                ),

                if (_isNewRecord) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '🏆 NEW RECORD!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFA000)),
                  ),
                ],

                const SizedBox(height: 28),

                // Buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Menu button
                    Flexible(
                      child: GestureDetector(
                        onTap: onMenu,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF78909C),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Text(
                                'MENU',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Retry button
                    Flexible(
                      child: AnimatedOpacity(
                        opacity: canRestart ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: canRestart ? onRestart : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF43A047),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  'RETRY',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
