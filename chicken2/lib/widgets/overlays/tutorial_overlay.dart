import 'package:flutter/material.dart';

/// First-time tutorial overlay explaining the game mechanics.
class TutorialOverlay extends StatelessWidget {
  final VoidCallback onDismiss;

  const TutorialOverlay({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: const Color(0xDD000000),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'HOW TO PLAY',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _row('🐔', 'Tap birds before they cross the river!'),
                    _row('🌟', 'Golden stars = big bonus points'),
                    _row('💣', "DON'T tap bombs!"),
                    _row('❤️', 'Hearts restore a life'),
                    _row('❄️', 'Freeze slows everything down'),
                    _row('🔥', 'Build combos for score multiplier'),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Tap anywhere to start!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _row(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(emoji,
                style: const TextStyle(fontSize: 28),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 17, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
