import '../models/exercise.dart';
import '../models/exercise_result.dart';
import 'app_logger.dart';

/// Статистика по категории
class CategoryStats {
  int sessionsPlayed;
  int totalExercises;
  int correctAnswers;
  Duration totalTime;

  CategoryStats({
    this.sessionsPlayed = 0,
    this.totalExercises = 0,
    this.correctAnswers = 0,
    this.totalTime = Duration.zero,
  });

  double get accuracy =>
      totalExercises > 0 ? correctAnswers / totalExercises : 0.0;

  Duration get averageTime =>
      totalExercises > 0
          ? Duration(milliseconds: totalTime.inMilliseconds ~/ totalExercises)
          : Duration.zero;
}

/// Сервис статистики (in-memory).
///
/// Хранит результаты сессий и предоставляет
/// агрегированную статистику по категориям.
class StatisticsService {
  static const _tag = 'Statistics';

  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  final List<SessionResult> _sessions = [];
  final Map<ExerciseCategory, CategoryStats> _categoryStats = {};

  /// Все завершённые сессии
  List<SessionResult> get sessions => List.unmodifiable(_sessions);

  /// Общее количество пройденных сессий
  int get totalSessions => _sessions.length;

  /// Общее количество решённых упражнений
  int get totalExercises =>
      _sessions.fold(0, (sum, s) => sum + s.totalExercises);

  /// Общее количество правильных ответов
  int get totalCorrect =>
      _sessions.fold(0, (sum, s) => sum + s.correctCount);

  /// Общая точность
  double get overallAccuracy =>
      totalExercises > 0 ? totalCorrect / totalExercises : 0.0;

  /// Записать результат сессии
  void recordSession(SessionResult result) {
    _sessions.add(result);

    final stats = _categoryStats.putIfAbsent(
      result.category,
      () => CategoryStats(),
    );
    stats.sessionsPlayed++;
    stats.totalExercises += result.totalExercises;
    stats.correctAnswers += result.correctCount;
    stats.totalTime += result.totalTime;

    AppLogger.info(
      'Сессия записана: ${result.category.label}, '
      'результат ${result.correctCount}/${result.totalExercises}',
      tag: _tag,
    );
  }

  /// Статистика по категории
  CategoryStats statsForCategory(ExerciseCategory category) {
    return _categoryStats[category] ?? CategoryStats();
  }

  /// Последние N сессий
  List<SessionResult> recentSessions({int count = 5}) {
    if (_sessions.length <= count) return List.unmodifiable(_sessions);
    return List.unmodifiable(
      _sessions.sublist(_sessions.length - count),
    );
  }

  /// Лучший результат по категории (% точности)
  double bestAccuracy(ExerciseCategory category) {
    final categorySessions =
        _sessions.where((s) => s.category == category).toList();
    if (categorySessions.isEmpty) return 0.0;
    return categorySessions
        .map((s) => s.accuracy)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Очистить всю статистику
  void reset() {
    _sessions.clear();
    _categoryStats.clear();
    AppLogger.info('Статистика сброшена', tag: _tag);
  }
}
