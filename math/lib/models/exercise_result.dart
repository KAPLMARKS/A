import 'exercise.dart';

/// Результат одного упражнения
class ExerciseResult {
  final Exercise exercise;
  final int? userAnswer;
  final Duration timeTaken;

  const ExerciseResult({
    required this.exercise,
    required this.userAnswer,
    required this.timeTaken,
  });

  bool get isCorrect => userAnswer == exercise.correctAnswer;

  bool get isSkipped => userAnswer == null;
}

/// Результат завершённой сессии упражнений
class SessionResult {
  final List<ExerciseResult> results;
  final ExerciseCategory category;
  final Difficulty difficulty;
  final DateTime completedAt;

  const SessionResult({
    required this.results,
    required this.category,
    required this.difficulty,
    required this.completedAt,
  });

  int get totalExercises => results.length;

  int get correctCount => results.where((r) => r.isCorrect).length;

  int get wrongCount => results.where((r) => !r.isCorrect && !r.isSkipped).length;

  int get skippedCount => results.where((r) => r.isSkipped).length;

  double get accuracy =>
      totalExercises > 0 ? correctCount / totalExercises : 0.0;

  Duration get totalTime =>
      results.fold(Duration.zero, (sum, r) => sum + r.timeTaken);

  Duration get averageTime =>
      totalExercises > 0
          ? Duration(
              milliseconds: totalTime.inMilliseconds ~/ totalExercises,
            )
          : Duration.zero;

  /// Оценка: от 0 до 5 звёзд
  int get starRating {
    final pct = accuracy * 100;
    if (pct >= 95) return 5;
    if (pct >= 80) return 4;
    if (pct >= 60) return 3;
    if (pct >= 40) return 2;
    if (pct >= 20) return 1;
    return 0;
  }
}
