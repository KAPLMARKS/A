import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

class TasksState extends Equatable {
  final List<Task> tasks;
  final Task? activeTask;
  final bool isLoading;

  const TasksState({
    this.tasks = const [],
    this.activeTask,
    this.isLoading = false,
  });

  TasksState copyWith({
    List<Task>? tasks,
    Task? activeTask,
    bool? isLoading,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      activeTask: activeTask ?? this.activeTask,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Task> get incompleteTasks {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<Task> get completedTasks {
    return tasks.where((task) => task.isCompleted).toList();
  }

  @override
  List<Object?> get props => [tasks, activeTask, isLoading];
}
