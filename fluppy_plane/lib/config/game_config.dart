import 'dart:ui';

/// All game constants, scaled proportionally to screen size.
/// Designed for a reference height of 800 logical pixels.
class GameConfig {
  final Size screenSize;

  GameConfig(this.screenSize);

  double get width => screenSize.width;
  double get height => screenSize.height;

  /// Scale factor relative to 800px reference height.
  double get scale => height / 800.0;

  // --------------- Physics ---------------
  double get gravity => 1400.0 * scale;
  double get jumpVelocity => -520.0 * scale;
  double get maxFallSpeed => 900.0 * scale;

  // --------------- Plane ---------------
  double get planeWidth => 60.0 * scale;
  double get planeHeight => 42.0 * scale;
  double get planeX => width * 0.25;
  double get planeStartY => height * 0.45;

  // --------------- Pipes ---------------
  double get pipeWidth => width * 0.17;
  double get pipeCapExtrusion => 5.0 * scale;
  double get pipeCapHeight => 26.0 * scale;
  double get pipeGapHeight => height * 0.23;
  double get pipeSpeed => 200.0 * scale;
  double get pipeSpawnInterval => 1.6;
  double get pipeMinGapCenter => height * 0.15 + pipeGapHeight / 2;
  double get pipeMaxGapCenter => groundY - height * 0.05 - pipeGapHeight / 2;

  // --------------- Ground ---------------
  double get groundHeight => height * 0.10;
  double get groundY => height - groundHeight;
  double get groundGrassHeight => 12.0 * scale;
  double get groundStripeWidth => 24.0 * scale;

  // --------------- Collision ---------------
  double get hitboxMargin => 5.0 * scale;

  // --------------- Visual ---------------
  double get cloudBaseSpeed => 40.0 * scale;
}
