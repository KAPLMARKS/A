import '../../domain/entities/task.dart';

class TasksHelper {
  TasksHelper._();

  static List<Task> getIncompleteTasks(List<Task> tasks) {
    return tasks.where((t) => !t.isCompleted).toList();
  }

  static List<Task> getCompletedTasks(List<Task> tasks) {
    return tasks.where((t) => t.isCompleted).toList();
  }
}
