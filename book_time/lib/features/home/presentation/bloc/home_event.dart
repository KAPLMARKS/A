import 'package:equatable/equatable.dart';
import '../../domain/entities/timer_mode.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeTimerStarted extends HomeEvent {
  const HomeTimerStarted();
}

class HomeTimerPaused extends HomeEvent {
  const HomeTimerPaused();
}

class HomeTimerResumed extends HomeEvent {
  const HomeTimerResumed();
}

class HomeTimerSkipped extends HomeEvent {
  const HomeTimerSkipped();
}

class HomeTimerTicked extends HomeEvent {
  final int remainingSeconds;
  
  const HomeTimerTicked(this.remainingSeconds);
  
  @override
  List<Object?> get props => [remainingSeconds];
}

class HomeTimerCompleted extends HomeEvent {
  const HomeTimerCompleted();
}

class HomeLoadActiveTask extends HomeEvent {
  const HomeLoadActiveTask();
}

class HomeModeChanged extends HomeEvent {
  final TimerMode mode;
  
  const HomeModeChanged(this.mode);
  
  @override
  List<Object?> get props => [mode];
}
