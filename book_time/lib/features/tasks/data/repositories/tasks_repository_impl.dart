import 'package:book_time/features/tasks/domain/entities/task_category.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_datasource.dart';
import '../models/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksLocalDataSource localDataSource;

  TasksRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() async {
    final models = await localDataSource.getTasks();
    final activeTaskId = await localDataSource.getActiveTaskId();

    return models.map((model) {
      return model.toEntity().copyWith(isActive: model.id == activeTaskId);
    }).toList();
  }

  @override
  Future<Task> addTask({
    required String title,
    TaskCategory category = TaskCategory.focus,
    int estimatedSessions = 1,
    String? note,
  }) async {
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      estimatedSessions: estimatedSessions,
      note: note,
      createdAt: DateTime.now(),
      isCompleted: false,
      isActive: false,
      completedSessions: 0,
    );

    final saved = await localDataSource.saveTask(task);
    return saved.toEntity();
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    final saved = await localDataSource.saveTask(model);
    return saved.toEntity();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final activeTaskId = await localDataSource.getActiveTaskId();
    if (activeTaskId == taskId) {
      await localDataSource.setActiveTaskId(null);
    }
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<void> setActiveTask(String? taskId) async {
    await localDataSource.setActiveTaskId(taskId);
  }

  @override
  Future<Task?> getActiveTask() async {
    final activeTaskId = await localDataSource.getActiveTaskId();
    if (activeTaskId == null) return null;

    final tasks = await getTasks();
    try {
      return tasks.firstWhere((t) => t.id == activeTaskId);
    } catch (_) {
      return null;
    }
  }
}
