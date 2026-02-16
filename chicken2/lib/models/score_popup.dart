import 'dart:ui';

/// Floating text popup that shows points earned.
class ScorePopup {
  double x, y;
  String text;
  Color color;
  double spawnTime;

  ScorePopup({
    required this.x,
    required this.y,
    required this.text,
    required this.color,
    required this.spawnTime,
  });
}
