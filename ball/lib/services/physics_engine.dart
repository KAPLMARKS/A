import 'dart:math';
import 'dart:ui';

import '../core/constants.dart';
import '../core/logger.dart';
import '../models/ball_model.dart';
import '../models/obstacle_model.dart';

/// Handles all physics calculations: gravity, collisions, friction.
class PhysicsEngine {
  final double gravity;
  final double airFriction;
  final double bounceFriction;
  final double wallBounceFriction;

  const PhysicsEngine({
    this.gravity = GameConstants.gravity,
    this.airFriction = GameConstants.airFriction,
    this.bounceFriction = GameConstants.bounceFriction,
    this.wallBounceFriction = GameConstants.wallBounceFriction,
  });

  /// Updates the ball position and velocity for one time step.
  /// Returns true if a bounce occurred.
  bool update(BallModel ball, double dt, Size bounds) {
    bool bounced = false;

    // Apply gravity
    ball.velocity = Offset(
      ball.velocity.dx,
      ball.velocity.dy + gravity * dt,
    );

    // Apply air friction
    ball.velocity = ball.velocity * airFriction;

    // Clamp velocity
    if (ball.speed > GameConstants.maxVelocity) {
      final scale = GameConstants.maxVelocity / ball.speed;
      ball.velocity = ball.velocity * scale;
    }

    // Update position
    ball.position = ball.position + ball.velocity * dt;

    // Wall collisions
    bounced |= _handleWallCollisions(ball, bounds);

    // Stop micro-movements
    if (ball.speed < GameConstants.minVelocity &&
        ball.bottom >= bounds.height - 1) {
      ball.velocity = Offset.zero;
    }

    // Trail
    ball.addTrailPoint(GameConstants.maxTrailLength);

    return bounced;
  }

  /// Checks and resolves ball-wall collisions.
  bool _handleWallCollisions(BallModel ball, Size bounds) {
    bool bounced = false;

    // Floor
    if (ball.bottom >= bounds.height) {
      ball.position = Offset(
        ball.position.dx,
        bounds.height - ball.radius,
      );
      ball.velocity = Offset(
        ball.velocity.dx * wallBounceFriction,
        -ball.velocity.dy.abs() * bounceFriction,
      );
      bounced = true;
    }

    // Ceiling
    if (ball.top <= 0) {
      ball.position = Offset(ball.position.dx, ball.radius);
      ball.velocity = Offset(
        ball.velocity.dx,
        ball.velocity.dy.abs() * bounceFriction,
      );
      bounced = true;
    }

    // Left wall
    if (ball.left <= 0) {
      ball.position = Offset(ball.radius, ball.position.dy);
      ball.velocity = Offset(
        ball.velocity.dx.abs() * wallBounceFriction,
        ball.velocity.dy,
      );
      bounced = true;
    }

    // Right wall
    if (ball.right >= bounds.width) {
      ball.position = Offset(bounds.width - ball.radius, ball.position.dy);
      ball.velocity = Offset(
        -ball.velocity.dx.abs() * wallBounceFriction,
        ball.velocity.dy,
      );
      bounced = true;
    }

    return bounced;
  }

  /// Checks and resolves ball-obstacle collisions.
  /// Returns points awarded for hits.
  int handleObstacleCollisions(
    BallModel ball,
    List<ObstacleModel> obstacles,
  ) {
    int points = 0;

    for (final obstacle in obstacles) {
      if (!_isBallIntersectingRect(ball, obstacle.rect)) continue;

      // Determine collision side
      final ballCenter = ball.position;
      final closestX = ballCenter.dx.clamp(obstacle.rect.left, obstacle.rect.right);
      final closestY = ballCenter.dy.clamp(obstacle.rect.top, obstacle.rect.bottom);

      final dx = ballCenter.dx - closestX;
      final dy = ballCenter.dy - closestY;
      final dist = sqrt(dx * dx + dy * dy);

      if (dist >= ball.radius) continue;

      // Resolve penetration
      final overlap = ball.radius - dist;
      if (dist > 0) {
        final nx = dx / dist;
        final ny = dy / dist;
        ball.position = Offset(
          ball.position.dx + nx * overlap,
          ball.position.dy + ny * overlap,
        );

        // Reflect velocity
        final dot = ball.velocity.dx * nx + ball.velocity.dy * ny;
        ball.velocity = Offset(
          (ball.velocity.dx - 2 * dot * nx) * bounceFriction,
          (ball.velocity.dy - 2 * dot * ny) * bounceFriction,
        );
      } else {
        // Ball center is inside obstacle - push out vertically
        ball.position = Offset(
          ball.position.dx,
          obstacle.rect.top - ball.radius,
        );
        ball.velocity = Offset(
          ball.velocity.dx,
          -ball.velocity.dy.abs() * bounceFriction,
        );
      }

      if (!obstacle.wasHit) {
        obstacle.wasHit = true;
        points += 10;
        AppLogger.gameEvent('Obstacle hit! +10 points');
      }
      points += 1;
    }

    return points;
  }

  bool _isBallIntersectingRect(BallModel ball, Rect rect) {
    final closestX = ball.position.dx.clamp(rect.left, rect.right);
    final closestY = ball.position.dy.clamp(rect.top, rect.bottom);
    final dx = ball.position.dx - closestX;
    final dy = ball.position.dy - closestY;
    return (dx * dx + dy * dy) <= (ball.radius * ball.radius);
  }

  /// Launches the ball with a velocity based on the drag vector.
  void launchBall(BallModel ball, Offset dragDelta) {
    ball.velocity = Offset(
      -dragDelta.dx * GameConstants.launchMultiplier,
      -dragDelta.dy * GameConstants.launchMultiplier,
    );
    ball.clearTrail();
    AppLogger.gameEvent(
      'Ball launched: vx=${ball.velocity.dx.toStringAsFixed(1)}, '
      'vy=${ball.velocity.dy.toStringAsFixed(1)}',
    );
  }
}
