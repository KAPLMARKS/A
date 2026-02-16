import '../entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Statistics> getStatistics();
  Future<void> incrementFocusSessions();
  Future<void> addFocusedMinutes(int minutes);
  Future<void> incrementTasksCompleted();
  Future<void> resetStatistics();
}
