import 'package:book_time/core/services/storage_service.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StorageService storageService;

  StatisticsRepositoryImpl(this.storageService);

  @override
  Future<Statistics> getStatistics() async {
    final statsJson = await storageService.loadStatistics();
    final dailyJson = await storageService.loadDailyFocusMinutes();
    
    final dailyFocusMinutes = <DateTime, int>{};
    for (final entry in dailyJson.entries) {
      dailyFocusMinutes[DateTime.parse(entry.key)] = entry.value;
    }

    final lastFocusDateStr = statsJson['lastFocusDate'] as String?;
    DateTime? lastFocusDate;
    if (lastFocusDateStr != null) {
      lastFocusDate = DateTime.parse(lastFocusDateStr);
    }

    return Statistics(
      focusSessionsCompleted:
          (statsJson['focusSessionsCompleted'] as num?)?.toInt() ?? 0,
      totalFocusedMinutes:
          (statsJson['totalFocusedMinutes'] as num?)?.toInt() ?? 0,
      tasksCompleted: (statsJson['tasksCompleted'] as num?)?.toInt() ?? 0,
      currentStreak: (statsJson['currentStreak'] as num?)?.toInt() ?? 0,
      lastFocusDate: lastFocusDate,
      dailyFocusMinutes: dailyFocusMinutes,
    );
  }

  @override
  Future<void> incrementFocusSessions() async {
    final stats = await getStatistics();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int newStreak = stats.currentStreak;
    if (stats.lastFocusDate != null) {
      final lastDate = DateTime(
        stats.lastFocusDate!.year,
        stats.lastFocusDate!.month,
        stats.lastFocusDate!.day,
      );
      final daysDiff = today.difference(lastDate).inDays;
      
      if (daysDiff == 1) {
        newStreak = stats.currentStreak + 1;
      } else if (daysDiff > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    await storageService.saveStatistics({
      'focusSessionsCompleted': stats.focusSessionsCompleted + 1,
      'totalFocusedMinutes': stats.totalFocusedMinutes,
      'tasksCompleted': stats.tasksCompleted,
      'currentStreak': newStreak,
      'lastFocusDate': now.toIso8601String(),
    });
  }

  @override
  Future<void> addFocusedMinutes(int minutes) async {
    final stats = await getStatistics();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final dailyMinutes = Map<DateTime, int>.from(stats.dailyFocusMinutes);
    final currentMinutes = dailyMinutes[today] ?? 0;
    dailyMinutes[today] = currentMinutes + minutes;
    
    final dailyJson = <String, int>{};
    for (final entry in dailyMinutes.entries) {
      dailyJson[entry.key.toIso8601String()] = entry.value;
    }
    
    await storageService.saveDailyFocusMinutes(dailyJson);
    await storageService.saveStatistics({
      'focusSessionsCompleted': stats.focusSessionsCompleted,
      'totalFocusedMinutes': stats.totalFocusedMinutes + minutes,
      'tasksCompleted': stats.tasksCompleted,
      'currentStreak': stats.currentStreak,
      'lastFocusDate': stats.lastFocusDate?.toIso8601String(),
    });
  }

  @override
  Future<void> incrementTasksCompleted() async {
    final stats = await getStatistics();
    await storageService.saveStatistics({
      'focusSessionsCompleted': stats.focusSessionsCompleted,
      'totalFocusedMinutes': stats.totalFocusedMinutes,
      'tasksCompleted': stats.tasksCompleted + 1,
      'currentStreak': stats.currentStreak,
      'lastFocusDate': stats.lastFocusDate?.toIso8601String(),
    });
  }

  @override
  Future<void> resetStatistics() async {
    await storageService.saveStatistics({
      'focusSessionsCompleted': 0,
      'totalFocusedMinutes': 0,
      'tasksCompleted': 0,
      'currentStreak': 0,
      'lastFocusDate': null,
    });
    await storageService.saveDailyFocusMinutes({});
  }
}
