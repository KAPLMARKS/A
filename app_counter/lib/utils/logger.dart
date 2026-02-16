import 'dart:developer' as developer;

/// Simple logger utility for the app.
/// Avoids exposing sensitive data in logs.
class AppLogger {
  AppLogger._();

  static void info(String message) {
    developer.log('[INFO] $message', name: 'AppCounter');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      '[ERROR] $message',
      name: 'AppCounter',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
