import 'package:flutter/material.dart';

import '../core/constants.dart';

/// Displays the score and high score with a glassy overlay style.
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int highScore;
  final int bounces;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.highScore,
    required this.bounces,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScoreCard('SCORE', score.toString()),
            _buildScoreCard('BOUNCES', bounces.toString()),
            _buildScoreCard('BEST', highScore.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GameConstants.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: GameConstants.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
