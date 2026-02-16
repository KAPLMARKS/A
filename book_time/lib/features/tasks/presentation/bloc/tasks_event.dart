import 'package:equatable/equatable.dart';
import '../../domain/entities/task_category.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class TasksLoaded extends TasksEvent {
  const TasksLoaded();
}

class TaskAdded extends TasksEvent {
  final String title;
  final TaskCategory category;
  final int estimatedSessions;
  final String? note;
  
  const TaskAdded({
    required this.title,
    this.category = TaskCategory.focus,
    this.estimatedSessions = 1,
    this.note,
  });
  
  @override
  List<Object?> get props => [title, category, estimatedSessions, note];
}

class TaskToggled extends TasksEvent {
  final String taskId;
  
  const TaskToggled(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class TaskDeleted extends TasksEvent {
  final String taskId;
  
  const TaskDeleted(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class TaskActivated extends TasksEvent {
  final String taskId;
  
  const TaskActivated(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class ActiveTaskCleared extends TasksEvent {
  const ActiveTaskCleared();
}
