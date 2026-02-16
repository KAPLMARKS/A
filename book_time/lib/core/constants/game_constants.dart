class GameConstants {
  GameConstants._();

  // Airplane properties
  static const double airplaneWidth = 60.0; // Visual width of airplane sprite
  static const double airplaneHeight = 60.0; // Visual height of airplane sprite
  static const double airplaneX =
      0.15; // Fixed horizontal position (15% from left)
  static const double airplaneStartY =
      0.5; // Start at middle vertically (0.0 - 1.0)

  // Airplane collision hitbox (larger than visual for more forgiving collisions)
  static const double airplaneHitboxWidth =
      60.0; // Collision width (25% larger than visual)
  static const double airplaneHitboxHeight =
      60.0; // Collision height (30% larger than visual)

  // Physics constants
  // Rebalanced for smooth, forgiving casual gameplay:
  // - Low gravity allows slow, graceful descent when idle
  // - Gentle tap impulse for predictable, controlled lift
  // - Velocity damping prevents explosive upward movement
  // - Player can maintain altitude with calm rhythmic taps
  static const double gravity =
      600.0; // px/s² - significantly reduced for slow, smooth falling
  static const double tapImpulse =
      -400.0; // px/s - increased for higher jump on tap
  static const double maxUpwardVelocity =
      -500.0; // px/s - increased to allow higher jumps
  static const double maxDownwardVelocity =
      500.0; // px/s - reduced for smooth, controlled descent
  static const double velocityDamping =
      0.98; // Per frame damping (0.98 = 2% velocity loss per frame) for smoothness

  // Obstacle properties
  static const double obstacleWidth = 100.0; // Width of obstacle column
  static const double obstacleGap =
      200.0; // Vertical gap between top and bottom obstacles
  static const double obstacleSpawnInterval =
      1.35; // Base seconds between obstacles (reduced from 2.5s for more dynamic gameplay)
  static const double obstacleSpawnRandomization =
      0.3; // Random variation (+/- 0.3s) to avoid predictable patterns
  static const double obstacleSpeed =
      200.0; // pixels per second (horizontal scroll speed)

  // Game boundaries
  static const double airplaneMinY = 0.0; // Top of screen (0.0 = top)
  static const double airplaneMaxY = 1.0; // Bottom of screen (1.0 = bottom)
  
  // UI constants
  static const double scoreTopPadding = 20.0;
  static const double pauseButtonTopPadding = 20.0;
  static const double pauseButtonRightPadding = 20.0;
  static const double pauseButtonIconSize = 32.0;
  static const double pauseButtonPadding = 12.0;
  static const double restartButtonTopPadding = 20.0;
  static const double restartButtonRightPadding = 20.0;
  static const double restartButtonIconSize = 24.0;
  static const double restartButtonPadding = 12.0;
  
  // Dialog constants
  static const double dialogBorderRadius = 20.0;
  static const double dialogButtonBorderRadius = 12.0;
  static const double dialogButtonVerticalPadding = 16.0;
  static const double dialogButtonSpacing = 12.0;
  static const double dialogTitleFontSize = 24.0;
  static const double dialogButtonFontSize = 18.0;
  
  // Score display
  static const double scoreHorizontalPadding = 24.0;
  static const double scoreVerticalPadding = 12.0;
  static const double scoreBorderRadius = 20.0;
  static const double scoreFontSize = 24.0;

  // Game timing
  static const double gameUpdateInterval = 0.016; // ~60 FPS (16ms)
  static const double scoreUpdateInterval = 1.0; // Update score every second
}
