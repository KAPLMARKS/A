import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants.dart';
import 'screens/home_screen.dart';

/// Root application widget.
class BallPhysicsApp extends StatelessWidget {
  const BallPhysicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock to portrait orientation for optimal gameplay
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Full-screen immersive mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: GameConstants.backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Ball Physics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: GameConstants.primaryColor,
        scaffoldBackgroundColor: GameConstants.backgroundColor,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: GameConstants.primaryColor,
          secondary: GameConstants.accentColor,
          surface: GameConstants.surfaceColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
