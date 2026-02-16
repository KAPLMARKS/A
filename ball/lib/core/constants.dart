import 'dart:ui';

/// Game physics and visual constants.
abstract final class GameConstants {
  // Physics
  static const double gravity = 980.0;
  static const double airFriction = 0.999;
  static const double bounceFriction = 0.75;
  static const double wallBounceFriction = 0.85;
  static const double minVelocity = 5.0;
  static const double maxVelocity = 2500.0;
  static const double launchMultiplier = 3.5;

  // Ball
  static const double defaultBallRadius = 22.0;
  static const double minBallRadius = 14.0;
  static const double maxBallRadius = 30.0;
  static const int maxTrailLength = 30;

  // Obstacles
  static const double obstacleHeight = 14.0;
  static const double minObstacleWidth = 60.0;
  static const double maxObstacleWidth = 160.0;
  static const int obstacleCount = 6;

  // Visual
  static const double scoreAnimationDuration = 0.5;
  static const int targetFps = 60;
  static const Duration frameDuration =
      Duration(microseconds: 1000000 ~/ targetFps);

  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFFFF6584);
  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color surfaceColor = Color(0xFF16213E);
  static const Color textColor = Color(0xFFE8E8E8);
}
