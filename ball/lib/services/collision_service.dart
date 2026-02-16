import 'dart:math';

import 'package:flutter/painting.dart';

import '../core/constants.dart';
import '../models/obstacle_model.dart';

/// Generates and manages obstacle layout.
class CollisionService {
  final Random _random = Random();

  /// Generates a set of randomized obstacles within the given bounds.
  List<ObstacleModel> generateObstacles(Size bounds) {
    final obstacles = <ObstacleModel>[];
    const count = GameConstants.obstacleCount;

    final sectionHeight = bounds.height / (count + 2);

    for (int i = 0; i < count; i++) {
      final width = _randomRange(
        GameConstants.minObstacleWidth,
        GameConstants.maxObstacleWidth,
      );
      final x = _randomRange(width / 2 + 10, bounds.width - width / 2 - 10);
      final y = sectionHeight * (i + 1.5);

      final hue = (i * 360.0 / count) % 360;
      final color = HSVColor.fromAHSV(1.0, hue, 0.6, 0.85).toColor();

      obstacles.add(
        ObstacleModel.fromCenter(
          center: Offset(x, y),
          width: width,
          height: GameConstants.obstacleHeight,
          color: color,
        ),
      );
    }

    return obstacles;
  }

  /// Resets the hit state of all obstacles.
  void resetObstacles(List<ObstacleModel> obstacles) {
    for (final o in obstacles) {
      o.wasHit = false;
    }
  }

  double _randomRange(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }
}
