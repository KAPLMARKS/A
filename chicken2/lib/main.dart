import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const PopChickenApp());
}

class PopChickenApp extends StatelessWidget {
  const PopChickenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pop Chicken',
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}
