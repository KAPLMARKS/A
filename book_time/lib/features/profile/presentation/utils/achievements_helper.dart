import '../../domain/entities/statistics.dart';
import '../../domain/entities/achievement.dart';

class AchievementsHelper {
  AchievementsHelper._();

  static List<Achievement> getAchievements(Statistics statistics) {
    return [
      Achievement(
        title: 'First Focus',
        isUnlocked: statistics.focusSessionsCompleted >= 1,
      ),
      Achievement(
        title: '100 Min',
        isUnlocked: statistics.totalFocusedMinutes >= 100,
      ),
      Achievement(
        title: '10 Tasks',
        isUnlocked: statistics.tasksCompleted >= 10,
      ),
      Achievement(
        title: '7 Day Streak',
        isUnlocked: statistics.currentStreak >= 7,
      ),
      Achievement(
        title: 'Level 5',
        isUnlocked: statistics.level >= 5,
      ),
      Achievement(
        title: '500 Min',
        isUnlocked: statistics.totalFocusedMinutes >= 500,
      ),
    ];
  }
}
