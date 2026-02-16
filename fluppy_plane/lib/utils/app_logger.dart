import 'dart:developer' as developer;

/// Lightweight logger for game events.
///
/// Uses `dart:developer` log – visible in debug console,
/// never exposes sensitive data.
class AppLogger {
  AppLogger._();

  static void info(String message) {
    developer.log(message, name: 'FluppyPlane');
  }

  static void warning(String message) {
    developer.log('⚠ $message', name: 'FluppyPlane', level: 900);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      '✖ $message',
      name: 'FluppyPlane',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
