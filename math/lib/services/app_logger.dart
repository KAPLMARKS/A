import 'dart:developer' as developer;

/// Уровни логирования
enum LogLevel { debug, info, warning, error }

/// Сервис логирования приложения.
///
/// Централизованное логирование с поддержкой уровней.
/// Чувствительные данные не выводятся в логи.
class AppLogger {
  static LogLevel _minLevel = LogLevel.debug;

  AppLogger._();

  /// Установить минимальный уровень логирования
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final prefix = switch (level) {
      LogLevel.debug => '[DEBUG]',
      LogLevel.info => '[INFO]',
      LogLevel.warning => '[WARN]',
      LogLevel.error => '[ERROR]',
    };

    final tagStr = tag != null ? '[$tag]' : '';
    final logMessage = '$prefix$tagStr $message';

    developer.log(
      logMessage,
      name: 'MathApp',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
