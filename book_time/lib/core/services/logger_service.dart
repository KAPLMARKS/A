import 'package:talker_flutter/talker_flutter.dart';
import '../bloc/bloc_providers.dart';

class LoggerService {
  LoggerService._();

  static Talker get _talker => getIt<Talker>();

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.debug(message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.info(message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.warning(message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }

  static void verbose(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.verbose(message, error, stackTrace);
  }
}

