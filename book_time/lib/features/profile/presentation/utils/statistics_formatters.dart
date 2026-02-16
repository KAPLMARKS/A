import '../../domain/entities/statistics.dart';
import 'statistics_extensions.dart';

class StatisticsFormatters {
  StatisticsFormatters._();

  static String getDailyStatus(Statistics statistics) {
    final todayMinutes = statistics.getTodayMinutes();
    if (todayMinutes == 0) {
      return 'Ready to focus? 💪';
    } else if (todayMinutes < 60) {
      return 'Great start! ✨';
    } else if (todayMinutes < 120) {
      return 'On fire! 🔥';
    } else {
      return 'Amazing focus! 🌟';
    }
  }

  static String formatFocusTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    return '${(minutes / 60).toStringAsFixed(1)}h';
  }
}
