import 'dart:ui';

import '../core/constants.dart';
import '../core/logger.dart';
import '../models/ball_model.dart';
import '../models/game_state.dart';
import '../models/obstacle_model.dart';
import 'collision_service.dart';
import 'physics_engine.dart';
import 'score_service.dart';

/// Central game controller that orchestrates physics, scoring, and state.
class GameController {
  final PhysicsEngine _physics = const PhysicsEngine();
  final CollisionService _collisionService = CollisionService();
  final ScoreService _scoreService = ScoreService();

  late BallModel ball;
  late GameState state;
  List<ObstacleModel> obstacles = [];
  Size _bounds = Size.zero;

  /// Whether the player is currently dragging the ball.
  bool isDragging = false;
  Offset dragStart = Offset.zero;
  Offset dragCurrent = Offset.zero;

  GameController() {
    state = GameState();
    ball = _createDefaultBall();
  }

  /// Initializes the game for the given screen size.
  void initialize(Size bounds) {
    _bounds = bounds;
    ball = _createDefaultBall();
    ball.position = Offset(bounds.width / 2, bounds.height * 0.3);
    obstacles = _collisionService.generateObstacles(bounds);
    state.reset();
    state.status = GameStatus.ready;
    AppLogger.gameEvent('Game initialized: ${bounds.width}x${bounds.height}');
  }

  /// Main update tick: advances physics, detects collisions, updates score.
  void update(double dt) {
    if (state.status != GameStatus.playing) return;
    if (dt > 0.05) dt = 0.05; // Cap delta to avoid tunneling

    state.elapsedTime += dt;

    final bounced = _physics.update(ball, dt, _bounds);
    if (bounced) {
      _scoreService.awardBouncePoints(state);
      ball.bounceCount++;
    }

    final obstaclePoints = _physics.handleObstacleCollisions(ball, obstacles);
    if (obstaclePoints > 0) {
      _scoreService.awardObstaclePoints(state, obstaclePoints);
    }
  }

  /// Handles the start of a touch/drag gesture on the ball.
  void onDragStart(Offset position) {
    if (state.status == GameStatus.gameOver) return;

    final distance = (position - ball.position).distance;
    if (distance <= ball.radius * 3) {
      isDragging = true;
      dragStart = position;
      dragCurrent = position;

      if (state.status == GameStatus.ready) {
        state.status = GameStatus.playing;
        AppLogger.gameEvent('Game started via drag');
      }
    }
  }

  /// Handles drag movement.
  void onDragUpdate(Offset position) {
    if (!isDragging) return;
    dragCurrent = position;
  }

  /// Handles drag release: launches the ball.
  void onDragEnd() {
    if (!isDragging) return;
    isDragging = false;

    final delta = dragCurrent - dragStart;
    if (delta.distance > 10) {
      _physics.launchBall(ball, delta);
    }
  }

  /// Handles a simple tap: gives the ball an upward impulse.
  void onTap(Offset position) {
    if (state.status == GameStatus.gameOver) {
      restartGame();
      return;
    }

    if (state.status == GameStatus.ready) {
      state.status = GameStatus.playing;
    }

    // Apply impulse toward the tap position
    final direction = (position - ball.position);
    final normalizedDir =
        direction / (direction.distance == 0 ? 1 : direction.distance);
    ball.velocity = ball.velocity +
        Offset(
          normalizedDir.dx * 500,
          normalizedDir.dy * 500,
        );
    AppLogger.gameEvent('Tap impulse applied');
  }

  /// Restarts the game, regenerating obstacles.
  void restartGame() {
    _scoreService.finalizeGame(state);
    state.reset();
    ball = _createDefaultBall();
    ball.position = Offset(_bounds.width / 2, _bounds.height * 0.3);
    obstacles = _collisionService.generateObstacles(_bounds);
    AppLogger.gameEvent('Game restarted');
  }

  /// Pauses or resumes the game.
  void togglePause() {
    if (state.status == GameStatus.playing) {
      state.status = GameStatus.paused;
      AppLogger.gameEvent('Game paused');
    } else if (state.status == GameStatus.paused) {
      state.status = GameStatus.playing;
      AppLogger.gameEvent('Game resumed');
    }
  }

  /// Gets the drag indicator line for rendering.
  (Offset start, Offset end)? get dragLine {
    if (!isDragging) return null;
    return (dragStart, dragCurrent);
  }

  BallModel _createDefaultBall() {
    return BallModel(
      position: Offset.zero,
      radius: GameConstants.defaultBallRadius,
      color: GameConstants.accentColor,
    );
  }
}
