import 'package:flutter/material.dart';

import 'screens/game_screen.dart';

class FluppyPlaneApp extends StatelessWidget {
  const FluppyPlaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluppy Plane',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
