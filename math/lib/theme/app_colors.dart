import 'package:flutter/material.dart';

/// Цветовая палитра приложения
abstract final class AppColors {
  // Основные цвета
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D9);

  // Фоновые цвета
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF141422);

  // Текстовые цвета
  static const Color textPrimary = Color(0xFF2D2D3A);
  static const Color textSecondary = Color(0xFF6E6E82);
  static const Color textOnPrimary = Colors.white;

  // Статус
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Градиенты для категорий
  static const List<List<Color>> categoryGradients = [
    [Color(0xFF6C63FF), Color(0xFF9D97FF)], // Сложение
    [Color(0xFFFF6B6B), Color(0xFFFF9A9A)], // Вычитание
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)], // Умножение
    [Color(0xFFFFBE0B), Color(0xFFFFD166)], // Деление
    [Color(0xFFAD56F5), Color(0xFFC98AFF)], // Смешанные
  ];

  static List<Color> gradientForIndex(int index) {
    return categoryGradients[index % categoryGradients.length];
  }
}
