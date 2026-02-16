import 'package:flutter/material.dart';

/// Large score number shown at the top of the screen during gameplay.
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            '$score',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(color: Color(0x88000000), blurRadius: 6, offset: Offset(2, 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
