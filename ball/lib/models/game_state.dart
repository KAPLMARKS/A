/// Possible states of the game.
enum GameStatus {
  /// Waiting for the player to start.
  ready,

  /// Game is actively running.
  playing,

  /// Game is paused.
  paused,

  /// Game has ended.
  gameOver,
}

/// Holds the overall state of the game session.
class GameState {
  GameStatus status;
  int score;
  int highScore;
  int totalBounces;
  double elapsedTime;

  GameState({
    this.status = GameStatus.ready,
    this.score = 0,
    this.highScore = 0,
    this.totalBounces = 0,
    this.elapsedTime = 0.0,
  });

  /// Resets the session while preserving the high score.
  void reset() {
    status = GameStatus.ready;
    score = 0;
    totalBounces = 0;
    elapsedTime = 0.0;
  }

  /// Updates the high score if the current score exceeds it.
  void updateHighScore() {
    if (score > highScore) {
      highScore = score;
    }
  }
}
