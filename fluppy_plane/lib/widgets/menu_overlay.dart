import 'package:flutter/material.dart';

/// Start‑screen overlay shown before the first tap.
class MenuOverlay extends StatelessWidget {
  const MenuOverlay({super.key, required this.highScore});

  final int highScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0x44000000)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'FLUPPY\nPLANE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 3,
                  shadows: const [
                    Shadow(color: Color(0x88000000), blurRadius: 10, offset: Offset(2, 3)),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Play prompt
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Color(0x44000000), blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                child: const Text(
                  'TAP TO PLAY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              if (highScore > 0) ...[
                const SizedBox(height: 24),
                Text(
                  'BEST: $highScore',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xBBFFFFFF),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
