/// Possible states of the game.
enum GameState {
  /// Title / start screen.
  menu,

  /// Active gameplay.
  playing,

  /// Player crashed – showing results.
  gameOver,
}
