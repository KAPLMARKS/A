/// Режимы таймера для чтения книг
enum TimerMode {
  /// Режим чтения - погружение в книгу
  reading,
  
  /// Короткий перерыв - отдых для глаз
  shortBreak,
  
  /// Длинный перерыв - время для размышлений
  longBreak;

  /// Длительность режима в минутах
  int get durationInMinutes {
    switch (this) {
      case TimerMode.reading:
        return 25; // Оптимальное время для концентрированного чтения
      case TimerMode.shortBreak:
        return 5; // Короткий отдых для глаз
      case TimerMode.longBreak:
        return 15; // Время обдумать прочитанное
    }
  }

  /// Отображаемое название режима
  String get displayName {
    switch (this) {
      case TimerMode.reading:
        return 'Reading';
      case TimerMode.shortBreak:
        return 'Rest Eyes';
      case TimerMode.longBreak:
        return 'Reflect';
    }
  }

  /// Описание режима
  String get description {
    switch (this) {
      case TimerMode.reading:
        return 'Dive into your book';
      case TimerMode.shortBreak:
        return 'Rest your eyes';
      case TimerMode.longBreak:
        return 'Reflect on what you read';
    }
  }

  /// Иконка режима
  String get iconName {
    switch (this) {
      case TimerMode.reading:
        return 'auto_stories';
      case TimerMode.shortBreak:
        return 'visibility_off';
      case TimerMode.longBreak:
        return 'psychology';
    }
  }
}
