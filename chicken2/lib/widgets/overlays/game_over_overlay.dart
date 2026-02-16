import 'package:flutter/material.dart';
import '../common_button.dart';

/// Game over screen with score summary and stats.
class GameOverOverlay extends StatelessWidget {
  final int score;
  final int highScore;
  final bool isNewRecord;
  final int wave;
  final int poppedCount;
  final int maxCombo;
  final String formattedTime;
  final VoidCallback onPlayAgain;
  final VoidCallback onMenu;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.isNewRecord,
    required this.wave,
    required this.poppedCount,
    required this.maxCombo,
    required this.formattedTime,
    required this.onPlayAgain,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xBB000000),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💥', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  const Text(
                    'GAME OVER',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFAB00),
                    ),
                  ),
                  if (isNewRecord) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'New Record!',
                      style: TextStyle(fontSize: 22, color: Color(0xFFFFD740)),
                    ),
                  ],
                  if (!isNewRecord && highScore > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Best: $highScore',
                      style: const TextStyle(fontSize: 18, color: Colors.white54),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _statRow('Wave reached', '$wave'),
                        _statRow('Popped', '$poppedCount'),
                        _statRow('Max combo', 'x$maxCombo'),
                        _statRow('Time', formattedTime),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  CommonButton(label: 'PLAY AGAIN', onTap: onPlayAgain),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: onMenu,
                    child: const Text(
                      'MENU',
                      style: TextStyle(fontSize: 17, color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 15, color: Colors.white54)),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
