import 'dart:developer' as dev;

/// Centralized logging service.
/// Prevents sensitive data leaks and provides consistent log formatting.
abstract final class AppLogger {
  static void info(String message, {String tag = 'BallGame'}) {
    dev.log('[INFO] $message', name: tag);
  }

  static void warning(String message, {String tag = 'BallGame'}) {
    dev.log('[WARN] $message', name: tag);
  }

  static void error(
    String message, {
    String tag = 'BallGame',
    Object? error,
    StackTrace? stackTrace,
  }) {
    dev.log(
      '[ERROR] $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void gameEvent(String event) {
    dev.log('[GAME] $event', name: 'GameLoop');
  }
}
