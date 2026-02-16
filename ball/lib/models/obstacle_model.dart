import 'dart:ui';

/// Represents a rectangular obstacle / platform.
class ObstacleModel {
  final Rect rect;
  final Color color;
  bool wasHit;

  ObstacleModel({
    required this.rect,
    required this.color,
    this.wasHit = false,
  });

  /// Factory for creating an obstacle from position and size.
  factory ObstacleModel.fromCenter({
    required Offset center,
    required double width,
    required double height,
    required Color color,
  }) {
    return ObstacleModel(
      rect: Rect.fromCenter(center: center, width: width, height: height),
      color: color,
    );
  }
}
