/// Represents the player's plane entity.
class PlaneModel {
  double x;
  double y;

  /// Vertical velocity (negative = upward).
  double velocity;

  /// Current visual rotation in radians.
  double rotation;

  PlaneModel({
    required this.x,
    required this.y,
    this.velocity = 0.0,
    this.rotation = 0.0,
  });

  /// Reset the plane to starting position.
  void reset(double startX, double startY) {
    x = startX;
    y = startY;
    velocity = 0.0;
    rotation = 0.0;
  }
}
