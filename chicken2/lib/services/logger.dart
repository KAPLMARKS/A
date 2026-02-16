import 'package:flutter/foundation.dart';

/// Simple logger that only prints in debug mode.
/// Avoids exposing sensitive data in release builds.
abstract final class Log {
  static void info(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] $message');
    }
  }

  static void warn(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[WARN][$tag] $message');
    }
  }

  static void error(String tag, String message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) {
      debugPrint('[ERROR][$tag] $message');
      if (error != null) debugPrint('  Exception: $error');
      if (stack != null) debugPrint('  $stack');
    }
  }
}
