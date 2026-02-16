/// Represents a pair of pipe obstacles (top + bottom).
class PipeModel {
  /// X position of the pipe's left edge.
  double x;

  /// Y center of the gap between top and bottom pipes.
  final double gapCenterY;

  /// Height of the gap.
  final double gapHeight;

  /// Width of the pipe column.
  final double width;

  /// Whether the player has already scored from passing this pipe.
  bool scored;

  PipeModel({
    required this.x,
    required this.gapCenterY,
    required this.gapHeight,
    required this.width,
    this.scored = false,
  });

  /// Bottom edge of the top pipe (= top of the gap).
  double get topPipeBottom => gapCenterY - gapHeight / 2;

  /// Top edge of the bottom pipe (= bottom of the gap).
  double get bottomPipeTop => gapCenterY + gapHeight / 2;

  /// Right edge of the pipe.
  double get rightEdge => x + width;
}
