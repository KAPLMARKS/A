import 'package:flutter/material.dart';

/// Full-screen wave number announcement that fades in/out.
class WaveAnnouncement extends StatelessWidget {
  final int wave;
  final double timer;

  const WaveAnnouncement({
    super.key,
    required this.wave,
    required this.timer,
  });

  @override
  Widget build(BuildContext context) {
    double opacity;
    if (timer > 1.5) {
      opacity = (2.0 - timer) / 0.5;
    } else if (timer < 0.5) {
      opacity = timer / 0.5;
    } else {
      opacity = 1.0;
    }
    opacity = opacity.clamp(0.0, 1.0);

    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Opacity(
            opacity: opacity,
            child: Text(
              'WAVE $wave',
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 16,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
