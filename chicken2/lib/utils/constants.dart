import 'package:flutter/material.dart';

/// Central place for all game constants.
abstract final class GameConstants {
  static const int maxLives = 5;
  static const int startLives = 3;
  static const double waveDuration = 18.0;
  static const double comboDuration = 2.0;
  static const double freezeDuration = 3.5;
  static const int maxComboMultiplier = 5;

  // Spawn timing
  static const double spawnDelay = 0.8;
  static const double minSpawnInterval = 0.28;
  static const double baseSpawnInterval = 1.8;
  static const double spawnIntervalWaveReduction = 0.12;
  static const double spawnIntervalTimeReduction = 0.002;

  // Pop animation
  static const double popDuration = 0.4;
  static const double popupDuration = 0.8;

  // Particles
  static const int featherCount = 10;
  static const double featherBaseSpeed = 120.0;
  static const double featherSpeedRange = 220.0;
  static const double featherLaunchVy = -180.0;
  static const double featherGravity = 400.0;
  static const double featherDecay = 2.5;

  // Colors — river theme
  static const Color riverDeep = Color(0xFF1565C0);
  static const Color riverMid = Color(0xFF1E88E5);
  static const Color riverLight = Color(0xFF42A5F5);
  static const Color riverFoam = Color(0xFFBBDEFB);
  static const Color grassDark = Color(0xFF388E3C);
  static const Color grassLight = Color(0xFF4CAF50);
  static const Color bankBrown = Color(0xFF6D4C41);

  // Default feather colors
  static const List<Color> defaultFeatherColors = [
    Color(0xFFFFCC80),
    Color(0xFFFFF176),
    Colors.white,
    Color(0xFFBCAAA4),
    Color(0xFFFFAB91),
  ];
}
