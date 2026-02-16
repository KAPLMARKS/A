import '../../domain/entities/statistics.dart';

extension StatisticsExtensions on Statistics {
  int getTodayMinutes() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return dailyFocusMinutes[todayDate] ?? 0;
  }

  int getTodaySessions() {
    final todayMinutes = getTodayMinutes();
    return todayMinutes > 0 ? (todayMinutes / 25).ceil() : 0;
  }
}
