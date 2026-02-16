import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('Application started');
  runApp(const App());
}
