import 'package:flutter/material.dart';

import 'app.dart';
import 'services/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('Приложение запущено', tag: 'Main');
  runApp(const MathExercisesApp());
}
