import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_category.dart';

class TaskStatisticsHelper {
  TaskStatisticsHelper._();

  static int getCompletedTasksCount(List<Task> tasks) {
    return tasks.where((t) => t.isCompleted).length;
  }

  static int getTotalEstimatedSessions(List<Task> tasks) {
    return tasks.fold<int>(
      0,
      (sum, task) => sum + task.estimatedSessions,
    );
  }

  static TaskCategory? getMostFocusedCategory(List<Task> tasks) {
    if (tasks.isEmpty) return null;

    final categoryCount = <TaskCategory, int>{};
    for (final task in tasks.where((t) => t.isCompleted)) {
      categoryCount[task.category] = (categoryCount[task.category] ?? 0) + 1;
    }

    if (categoryCount.isEmpty) return null;

    return categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
