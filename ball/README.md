# Ball Physics Game

A Flutter-based physics ball game with realistic bouncing mechanics, gravity, and collision detection.

## Features

- **Realistic Physics**: Gravity, air friction, bounce energy loss, and wall restitution
- **Touch Controls**: Drag to aim and launch the ball, tap to apply impulse
- **Obstacles**: Colored platforms scattered across the screen that award bonus points
- **Trail Effect**: Beautiful glowing trail behind the ball
- **Score System**: Points for bounces and obstacle hits with high score tracking
- **Dark Theme**: Modern dark UI with gradient backgrounds and glowing effects

## Project Structure

```
lib/
├── main.dart                    # Entry point with error handling
├── app.dart                     # MaterialApp configuration
├── core/
│   ├── constants.dart           # Physics & visual constants
│   └── logger.dart              # Centralized logging
├── models/
│   ├── ball_model.dart          # Ball data (position, velocity, trail)
│   ├── obstacle_model.dart      # Obstacle/platform data
│   └── game_state.dart          # Game state management
├── services/
│   ├── game_controller.dart     # Central game orchestrator
│   ├── physics_engine.dart      # Physics calculations
│   ├── collision_service.dart   # Obstacle generation & collision
│   └── score_service.dart       # Score tracking
├── screens/
│   ├── home_screen.dart         # Main menu with animations
│   └── game_screen.dart         # Game loop & rendering
└── widgets/
    ├── game_canvas.dart         # CustomPainter for game rendering
    ├── score_display.dart       # Score overlay widget
    └── menu_button.dart         # Styled button component
```

## How to Play

1. **Launch**: Drag the ball to aim, then release to launch
2. **Impulse**: Tap anywhere on screen to push the ball toward that point
3. **Bounce**: Ball bounces off walls and floor, earning 1 point per bounce
4. **Obstacles**: Hit colored platforms for bonus points (+10 for first hit)
5. **Restart**: Use the refresh button or tap after game over

## Building

### Prerequisites

- Flutter SDK 3.41.0+
- Android SDK

### Run in Debug

```bash
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`

## Technical Details

- **Rendering**: Custom `CustomPainter` for efficient canvas rendering
- **Game Loop**: `Ticker`-based 60fps update loop
- **Physics**: Custom engine with gravity (980 px/s²), bounce friction (0.75), air resistance
- **Collision**: Circle-AABB collision detection with penetration resolution
- **Adaptive**: Portrait-locked, adapts to any screen size
- **No external game engine**: Pure Flutter/Dart implementation

## Dependencies

- Flutter SDK (no external packages for game logic)
