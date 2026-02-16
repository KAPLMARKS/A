import 'package:flutter/material.dart';
import '../common_button.dart';

/// Overlay shown when the game is paused.
class PauseOverlay extends StatelessWidget {
  final int score;
  final int wave;
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseOverlay({
    super.key,
    required this.score,
    required this.wave,
    required this.onResume,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xBB000000),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pause_circle_outline,
                    color: Colors.white54, size: 72),
                const SizedBox(height: 12),
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: $score  ·  Wave: $wave',
                  style: const TextStyle(fontSize: 17, color: Colors.white54),
                ),
                const SizedBox(height: 36),
                CommonButton(label: 'RESUME', onTap: onResume),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: onQuit,
                  child: const Text(
                    'QUIT TO MENU',
                    style: TextStyle(fontSize: 17, color: Colors.white60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
