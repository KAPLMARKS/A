import 'dart:math';
import 'package:flutter/material.dart';

/// Heads-up display showing score, wave, lives, and pause button.
class HudWidget extends StatelessWidget {
  final int score;
  final int wave;
  final int lives;
  final VoidCallback onPause;

  const HudWidget({
    super.key,
    required this.score,
    required this.wave,
    required this.lives,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _pill(
                child: Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _pill(
                color: Colors.black38,
                child: Text(
                  'W$wave',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              _pill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(max(3, lives), (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Icon(
                        i < lives ? Icons.favorite : Icons.favorite_border,
                        color: i < lives
                            ? Colors.redAccent
                            : Colors.red.shade200,
                        size: 20,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onPause,
                child: _pill(
                  child: const Icon(Icons.pause, color: Colors.white70, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill({required Widget child, Color color = Colors.black54}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
