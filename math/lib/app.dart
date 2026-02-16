import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Корневой виджет приложения.
class MathExercisesApp extends StatelessWidget {
  const MathExercisesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Математика',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
