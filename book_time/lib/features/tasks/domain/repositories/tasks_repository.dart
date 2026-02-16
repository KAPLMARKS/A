import '../entities/task.dart';
import '../entities/task_category.dart';

abstract class TasksRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask({
    required String title,
    TaskCategory category = TaskCategory.focus,
    int estimatedSessions = 1,
    String? note,
  });
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> setActiveTask(String? taskId);
  Future<Task?> getActiveTask();
}
