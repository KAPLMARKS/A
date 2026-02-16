# Fluppy Plane ✈️

A **Flappy Bird**-style game built with pure Flutter — no external game engine.
Tap the screen to make the cartoon plane fly up, dodge the green pipes, and beat your high score!

## Project Structure

```
lib/
├── main.dart                   # Entry point
├── app.dart                    # MaterialApp configuration
├── config/
│   └── game_config.dart        # All game constants (scaled to screen)
├── models/
│   ├── game_state.dart         # Menu / Playing / GameOver enum
│   ├── plane_model.dart        # Plane entity (position, velocity)
│   └── pipe_model.dart         # Pipe-pair entity (gap, position)
├── services/
│   └── game_service.dart       # Core logic: physics, spawning, collision
├── painters/
│   └── game_painter.dart       # CustomPainter – renders the entire game
├── screens/
│   └── game_screen.dart        # Game screen widget + game loop (Ticker)
├── widgets/
│   ├── menu_overlay.dart       # Start menu overlay
│   ├── game_over_overlay.dart  # Game-over card
│   └── score_display.dart      # In-game score HUD
└── utils/
    └── app_logger.dart         # Lightweight logger (dart:developer)
```

## Running

```bash
flutter pub get
flutter run
```

## Key Design Decisions

| Aspect | Decision |
|---|---|
| **Game engine** | Pure Flutter `CustomPainter` + `Ticker` — zero external deps |
| **Graphics** | Procedurally drawn on Canvas (plane, pipes, clouds, ground) |
| **Screen adaptation** | All sizes scaled relative to a 800px reference height |
| **Architecture** | Clean separation: models → services → painters → screens |
| **Input** | Tap (mobile) + Space bar (desktop) |
| **Performance** | `RepaintBoundary` isolates the game canvas; game loop is a single `Ticker` |

## Controls

- **Tap** anywhere on screen to flap
- **Space bar** works on desktop for testing
