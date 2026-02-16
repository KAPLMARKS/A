import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/timer_mode.dart';
import '../../../tasks/domain/repositories/tasks_repository.dart';
import '../../../profile/domain/repositories/statistics_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC для управления таймером чтения книг
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TasksRepository tasksRepository;
  final StatisticsRepository statisticsRepository;
  Timer? _timer;

  HomeBloc({
    required this.tasksRepository,
    required this.statisticsRepository,
  }) : super(const HomeState(
          currentMode: TimerMode.reading,
          remainingSeconds: 1500, // 25 минут для чтения
        )) {
    on<HomeTimerStarted>(_onTimerStarted);
    on<HomeTimerPaused>(_onTimerPaused);
    on<HomeTimerResumed>(_onTimerResumed);
    on<HomeTimerSkipped>(_onTimerSkipped);
    on<HomeTimerTicked>(_onTimerTicked);
    on<HomeTimerCompleted>(_onTimerCompleted);
    on<HomeLoadActiveTask>(_onLoadActiveTask);
    on<HomeModeChanged>(_onModeChanged);
  }

  /// Обработка начала сессии чтения
  void _onTimerStarted(HomeTimerStarted event, Emitter<HomeState> emit) {
    if (state.remainingSeconds > 0 && !state.isRunning) {
      emit(state.copyWith(isRunning: true, isPaused: false));
      _startTimer();
    } else if (state.remainingSeconds == 0) {
      final newMode = _getNextMode();
      final newSeconds = newMode.durationInMinutes * 60;
      emit(state.copyWith(
        currentMode: newMode,
        remainingSeconds: newSeconds,
        isRunning: true,
        isPaused: false,
      ));
      _startTimer();
    }
  }

  /// Пауза - "закладка" в книге
  void _onTimerPaused(HomeTimerPaused event, Emitter<HomeState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false, isPaused: true));
  }

  /// Продолжение чтения
  void _onTimerResumed(HomeTimerResumed event, Emitter<HomeState> emit) {
    if (state.remainingSeconds > 0) {
      emit(state.copyWith(isRunning: true, isPaused: false));
      _startTimer();
    }
  }

  /// Пропуск текущей сессии
  void _onTimerSkipped(HomeTimerSkipped event, Emitter<HomeState> emit) {
    _timer?.cancel();
    final newMode = _getNextMode();
    final newSeconds = newMode.durationInMinutes * 60;
    emit(state.copyWith(
      currentMode: newMode,
      remainingSeconds: newSeconds,
      isRunning: false,
      isPaused: false,
    ));
  }

  /// Тик таймера (каждую секунду)
  void _onTimerTicked(HomeTimerTicked event, Emitter<HomeState> emit) {
    if (event.remainingSeconds <= 0) {
      add(const HomeTimerCompleted());
    } else {
      emit(state.copyWith(remainingSeconds: event.remainingSeconds));
    }
  }

  /// Завершение сессии чтения
  Future<void> _onTimerCompleted(
    HomeTimerCompleted event,
    Emitter<HomeState> emit,
  ) async {
    _timer?.cancel();
    
    // Если это была сессия чтения - записываем статистику
    if (state.currentMode == TimerMode.reading) {
      await statisticsRepository.incrementFocusSessions();
      await statisticsRepository.addFocusedMinutes(
        state.currentMode.durationInMinutes,
      );
      emit(state.copyWith(
        completedSessions: state.completedSessions + 1,
      ));
    }
    
    final newMode = _getNextMode();
    final newSeconds = newMode.durationInMinutes * 60;
    emit(state.copyWith(
      currentMode: newMode,
      remainingSeconds: newSeconds,
      isRunning: false,
      isPaused: false,
    ));
  }

  /// Загрузка активной книги
  Future<void> _onLoadActiveTask(
    HomeLoadActiveTask event,
    Emitter<HomeState> emit,
  ) async {
    final activeTask = await tasksRepository.getActiveTask();
    emit(state.copyWith(activeTask: activeTask));
  }

  /// Смена режима (чтение/перерыв)
  void _onModeChanged(
    HomeModeChanged event,
    Emitter<HomeState> emit,
  ) {
    _timer?.cancel();
    final newSeconds = event.mode.durationInMinutes * 60;
    emit(state.copyWith(
      currentMode: event.mode,
      remainingSeconds: newSeconds,
      isRunning: false,
      isPaused: false,
    ));
  }

  /// Запуск таймера
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.remainingSeconds - 1;
      add(HomeTimerTicked(remaining));
    });
  }

  /// Определение следующего режима
  /// После чтения - перерыв, после перерыва - чтение
  /// Каждые 3 сессии чтения - длинный перерыв
  TimerMode _getNextMode() {
    if (state.currentMode == TimerMode.reading) {
      final sessionCount = state.completedSessions + 1;
      if (sessionCount % 3 == 0) {
        return TimerMode.longBreak; // Время для размышлений
      } else {
        return TimerMode.shortBreak; // Отдых для глаз
      }
    } else {
      return TimerMode.reading; // Вернуться к чтению
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
