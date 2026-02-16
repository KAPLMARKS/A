import 'dart:math';
import 'dart:ui';

/// A particle emitted when a chicken is popped.
class Feather {
  double x, y, vx, vy;
  double life;
  Color color;
  double size;
  double rotation;
  double rotSpeed;

  Feather({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
  })  : life = 1.0,
        rotation = Random().nextDouble() * pi * 2,
        rotSpeed = (Random().nextDouble() - 0.5) * 10;
}
