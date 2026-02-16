import 'dart:ui';

/// Represents a ball with physics properties.
class BallModel {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  final List<Offset> trail;
  int bounceCount;

  BallModel({
    required this.position,
    this.velocity = Offset.zero,
    required this.radius,
    required this.color,
    this.bounceCount = 0,
  }) : trail = [];

  /// Ball bounds for collision detection.
  double get left => position.dx - radius;
  double get right => position.dx + radius;
  double get top => position.dy - radius;
  double get bottom => position.dy + radius;

  /// Current speed magnitude.
  double get speed => velocity.distance;

  /// Adds current position to the trail history.
  void addTrailPoint(int maxLength) {
    trail.add(position);
    if (trail.length > maxLength) {
      trail.removeAt(0);
    }
  }

  /// Clears the trail history.
  void clearTrail() {
    trail.clear();
  }
}
