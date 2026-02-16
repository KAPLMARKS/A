import '../../domain/entities/timer_mode.dart';

/// Помощник для работы с режимами таймера чтения
class TimerModeHelper {
  TimerModeHelper._();

  /// Получить индекс таба по режиму
  static int getTabIndex(TimerMode mode) {
    switch (mode) {
      case TimerMode.reading:
        return 0;
      case TimerMode.shortBreak:
        return 1;
      case TimerMode.longBreak:
        return 2;
    }
  }

  /// Получить режим по индексу таба
  static TimerMode getModeFromTabIndex(int index) {
    switch (index) {
      case 0:
        return TimerMode.reading;
      case 1:
        return TimerMode.shortBreak;
      case 2:
        return TimerMode.longBreak;
      default:
        return TimerMode.reading;
    }
  }
}
