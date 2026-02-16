import 'package:book_time/core/services/storage_service.dart';
import '../models/task_model.dart';

abstract class TasksLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> saveTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> setActiveTaskId(String? taskId);
  Future<String?> getActiveTaskId();
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final StorageService storageService;

  TasksLocalDataSourceImpl(this.storageService);

  @override
  Future<List<TaskModel>> getTasks() async {
    final tasksJson = await storageService.loadTasks();
    return tasksJson.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> saveTask(TaskModel task) async {
    final tasks = await getTasks();
    final existingIndex = tasks.indexWhere((t) => t.id == task.id);
    
    if (existingIndex >= 0) {
      tasks[existingIndex] = task;
    } else {
      tasks.add(task);
    }
    
    await storageService.saveTasks(
      tasks.map((t) => t.toJson()).toList(),
    );
    return task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await storageService.saveTasks(
      tasks.map((t) => t.toJson()).toList(),
    );
  }

  @override
  Future<void> setActiveTaskId(String? taskId) async {
    await storageService.saveActiveTaskId(taskId);
  }

  @override
  Future<String?> getActiveTaskId() async {
    return await storageService.loadActiveTaskId();
  }
}
