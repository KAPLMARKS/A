import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../../profile/domain/repositories/statistics_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository tasksRepository;
  final StatisticsRepository statisticsRepository;

  TasksBloc({
    required this.tasksRepository,
    required this.statisticsRepository,
  }) : super(const TasksState()) {
    on<TasksLoaded>(_onTasksLoaded);
    on<TaskAdded>(_onTaskAdded);
    on<TaskToggled>(_onTaskToggled);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskActivated>(_onTaskActivated);
    on<ActiveTaskCleared>(_onActiveTaskCleared);
  }

  Future<void> _onTasksLoaded(
    TasksLoaded event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await tasksRepository.getTasks();
      final activeTask = await tasksRepository.getActiveTask();
      emit(state.copyWith(
        tasks: tasks,
        activeTask: activeTask,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onTaskAdded(
    TaskAdded event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await tasksRepository.addTask(
        title: event.title,
        category: event.category,
        estimatedSessions: event.estimatedSessions,
        note: event.note,
      );
      final tasks = await tasksRepository.getTasks();
      final activeTask = await tasksRepository.getActiveTask();
      emit(state.copyWith(tasks: tasks, activeTask: activeTask));
    } catch (_) {
      // Error handling
    }
  }

  Future<void> _onTaskToggled(
    TaskToggled event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final task = state.tasks.firstWhere((t) => t.id == event.taskId);
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await tasksRepository.updateTask(updatedTask);
      
      if (updatedTask.isCompleted && !task.isCompleted) {
        await statisticsRepository.incrementTasksCompleted();
      }
      
      final tasks = await tasksRepository.getTasks();
      final activeTask = await tasksRepository.getActiveTask();
      emit(state.copyWith(tasks: tasks, activeTask: activeTask));
    } catch (_) {
      // Error handling
    }
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await tasksRepository.deleteTask(event.taskId);
      final tasks = await tasksRepository.getTasks();
      final activeTask = await tasksRepository.getActiveTask();
      emit(state.copyWith(tasks: tasks, activeTask: activeTask));
    } catch (_) {
      // Error handling
    }
  }

  Future<void> _onTaskActivated(
    TaskActivated event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await tasksRepository.setActiveTask(event.taskId);
      final tasks = await tasksRepository.getTasks();
      final activeTask = await tasksRepository.getActiveTask();
      emit(state.copyWith(tasks: tasks, activeTask: activeTask));
    } catch (_) {
      // Error handling
    }
  }

  Future<void> _onActiveTaskCleared(
    ActiveTaskCleared event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await tasksRepository.setActiveTask(null);
      final tasks = await tasksRepository.getTasks();
      emit(state.copyWith(tasks: tasks, activeTask: null));
    } catch (_) {
      // Error handling
    }
  }
}
