import '../core/logger.dart';
import '../models/game_state.dart';

/// Manages score tracking and high score persistence.
class ScoreService {
  /// Awards points for a wall/floor bounce.
  void awardBouncePoints(GameState state) {
    state.totalBounces++;
    state.score += 1;
  }

  /// Awards points from obstacle collisions.
  void awardObstaclePoints(GameState state, int points) {
    if (points > 0) {
      state.score += points;
      AppLogger.gameEvent(
        'Score: ${state.score} (+$points from obstacles)',
      );
    }
  }

  /// Finalizes the game: updates high score, logs result.
  void finalizeGame(GameState state) {
    state.updateHighScore();
    AppLogger.gameEvent(
      'Game over. Score: ${state.score}, High: ${state.highScore}',
    );
  }

  /// Resets the game state for a new round.
  void resetGame(GameState state) {
    state.reset();
    AppLogger.gameEvent('Game reset');
  }
}
