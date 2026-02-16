import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final int focusSessionsCompleted;
  final int totalFocusedMinutes;
  final int tasksCompleted;
  final int currentStreak;
  final DateTime? lastFocusDate;
  final Map<DateTime, int> dailyFocusMinutes;

  const Statistics({
    this.focusSessionsCompleted = 0,
    this.totalFocusedMinutes = 0,
    this.tasksCompleted = 0,
    this.currentStreak = 0,
    this.lastFocusDate,
    this.dailyFocusMinutes = const {},
  });

  int get xp {
    return focusSessionsCompleted * 10 + totalFocusedMinutes;
  }

  int get level {
    return (xp / 100).floor() + 1;
  }

  int get xpForCurrentLevel {
    return (level - 1) * 100;
  }

  int get xpForNextLevel {
    return level * 100;
  }

  int get currentLevelXp {
    return xp - xpForCurrentLevel;
  }

  int get xpNeededForNextLevel {
    return xpForNextLevel - xp;
  }

  double get levelProgress {
    final needed = xpNeededForNextLevel + currentLevelXp;
    if (needed == 0) return 1.0;
    return (currentLevelXp / needed).clamp(0.0, 1.0);
  }

  Map<String, int> get weeklyActivity {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    final Map<String, int> weekData = {};
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final minutes = dailyFocusMinutes[dateKey] ?? 0;
      weekData[_getDayName(i)] = minutes;
    }
    return weekData;
  }

  String _getDayName(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  Statistics copyWith({
    int? focusSessionsCompleted,
    int? totalFocusedMinutes,
    int? tasksCompleted,
    int? currentStreak,
    DateTime? lastFocusDate,
    Map<DateTime, int>? dailyFocusMinutes,
  }) {
    return Statistics(
      focusSessionsCompleted:
          focusSessionsCompleted ?? this.focusSessionsCompleted,
      totalFocusedMinutes: totalFocusedMinutes ?? this.totalFocusedMinutes,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      lastFocusDate: lastFocusDate ?? this.lastFocusDate,
      dailyFocusMinutes: dailyFocusMinutes ?? this.dailyFocusMinutes,
    );
  }

  @override
  List<Object?> get props => [
        focusSessionsCompleted,
        totalFocusedMinutes,
        tasksCompleted,
        currentStreak,
        lastFocusDate,
        dailyFocusMinutes,
      ];
}
