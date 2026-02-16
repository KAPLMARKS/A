import 'package:flutter/material.dart';

import 'app.dart';
import 'core/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('Application starting');

  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  runApp(const BallPhysicsApp());
}
