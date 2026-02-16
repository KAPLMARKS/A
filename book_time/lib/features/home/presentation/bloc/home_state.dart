import 'package:equatable/equatable.dart';
import '../../domain/entities/timer_mode.dart';
import '../../../tasks/domain/entities/task.dart';

/// Состояние домашнего экрана для чтения книг
class HomeState extends Equatable {
  /// Текущий режим таймера (чтение/перерыв)
  final TimerMode currentMode;
  
  /// Оставшееся время в секундах
  final int remainingSeconds;
  
  /// Запущен ли таймер
  final bool isRunning;
  
  /// На паузе ли таймер
  final bool isPaused;
  
  /// Количество завершённых сессий чтения
  final int completedSessions;
  
  /// Активная книга/задача
  final Task? activeTask;

  const HomeState({
    this.currentMode = TimerMode.reading,
    this.remainingSeconds = 1500, // 25 минут по умолчанию
    this.isRunning = false,
    this.isPaused = false,
    this.completedSessions = 0,
    this.activeTask,
  });

  HomeState copyWith({
    TimerMode? currentMode,
    int? remainingSeconds,
    bool? isRunning,
    bool? isPaused,
    int? completedSessions,
    Task? activeTask,
  }) {
    return HomeState(
      currentMode: currentMode ?? this.currentMode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      completedSessions: completedSessions ?? this.completedSessions,
      activeTask: activeTask ?? this.activeTask,
    );
  }

  /// Отформатированное время (MM:SS)
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Прогресс текущей сессии (0.0 - 1.0)
  double get progress {
    final totalSeconds = currentMode.durationInMinutes * 60;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  /// Количество прочитанных минут за сессию
  int get readMinutesThisSession {
    final totalSeconds = currentMode.durationInMinutes * 60;
    return (totalSeconds - remainingSeconds) ~/ 60;
  }

  @override
  List<Object?> get props => [
        currentMode,
        remainingSeconds,
        isRunning,
        isPaused,
        completedSessions,
        activeTask,
      ];
}
