import 'dart:math';

/// Types of items that can appear on screen.
enum ChickenType { normal, small, big, duck, baby, golden, bomb, heart, freeze }

/// A single game entity (bird, power-up, or hazard) moving across the river.
class Chicken {
  double x, y;
  final double baseY;
  double speed;
  double direction;
  double size;
  String emoji;
  int points;
  bool isPopped;
  double poppedAt;
  final double wobble;
  final ChickenType type;
  final double amplitude;
  final double freq;

  Chicken({
    required this.x,
    required this.y,
    required this.speed,
    required this.direction,
    required this.size,
    required this.emoji,
    required this.points,
    required this.type,
    this.amplitude = 4.0,
    this.freq = 6.0,
  })  : baseY = y,
        isPopped = false,
        poppedAt = 0,
        wobble = Random().nextDouble() * pi * 2;

  /// Whether this type represents a tappable bird (causes life loss on escape).
  bool get isBird =>
      type == ChickenType.normal ||
      type == ChickenType.small ||
      type == ChickenType.big ||
      type == ChickenType.duck ||
      type == ChickenType.baby;
}
