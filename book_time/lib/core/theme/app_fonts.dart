import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Шрифты приложения Book Time
/// Классический книжный стиль
/// 
/// Playfair Display - для крупных заголовков (элегантный сериф)
/// Crimson Pro - для подзаголовков (книжный стиль)
/// Lora - для основного текста (отличная читаемость)
class AppFonts {
  AppFonts._();

  // ═══════════════════════════════════════════════════════════════
  // СЕМЕЙСТВА ШРИФТОВ
  // ═══════════════════════════════════════════════════════════════
  
  /// Элегантный сериф для крупных заголовков
  static String get displayFamily => GoogleFonts.playfairDisplay().fontFamily!;
  
  /// Классический книжный для подзаголовков
  static String get headlineFamily => GoogleFonts.crimsonPro().fontFamily!;
  
  /// Читаемый сериф для основного текста
  static String get bodyFamily => GoogleFonts.lora().fontFamily!;

  // ═══════════════════════════════════════════════════════════════
  // РАЗМЕРЫ ШРИФТОВ
  // ═══════════════════════════════════════════════════════════════
  static const double size10 = 10.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size24 = 24.0;
  static const double size28 = 28.0;
  static const double size32 = 32.0;
  static const double size40 = 40.0;

  // ═══════════════════════════════════════════════════════════════
  // ВЕСА ШРИФТОВ
  // ═══════════════════════════════════════════════════════════════
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ═══════════════════════════════════════════════════════════════
  // DISPLAY - Крупные заголовки (Playfair Display)
  // ═══════════════════════════════════════════════════════════════
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: size40,
    fontWeight: bold,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: size32,
    fontWeight: bold,
    letterSpacing: -0.25,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: size28,
    fontWeight: semibold,
  );

  // ═══════════════════════════════════════════════════════════════
  // HEADLINE - Подзаголовки (Crimson Pro)
  // ═══════════════════════════════════════════════════════════════
  static TextStyle get headlineLarge => GoogleFonts.crimsonPro(
    fontSize: size24,
    fontWeight: semibold,
  );

  static TextStyle get headlineMedium => GoogleFonts.crimsonPro(
    fontSize: size20,
    fontWeight: semibold,
  );

  static TextStyle get headlineSmall => GoogleFonts.crimsonPro(
    fontSize: size18,
    fontWeight: medium,
  );

  // ═══════════════════════════════════════════════════════════════
  // TITLE - Заголовки секций (Crimson Pro)
  // ═══════════════════════════════════════════════════════════════
  static TextStyle get titleLarge => GoogleFonts.crimsonPro(
    fontSize: size18,
    fontWeight: semibold,
  );

  static TextStyle get titleMedium => GoogleFonts.crimsonPro(
    fontSize: size16,
    fontWeight: medium,
  );

  static TextStyle get titleSmall => GoogleFonts.crimsonPro(
    fontSize: size14,
    fontWeight: medium,
  );

  // ═══════════════════════════════════════════════════════════════
  // BODY - Основной текст (Lora)
  // ═══════════════════════════════════════════════════════════════
  static TextStyle get bodyLarge => GoogleFonts.lora(
    fontSize: size16,
    fontWeight: normal,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.lora(
    fontSize: size14,
    fontWeight: normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.lora(
    fontSize: size12,
    fontWeight: normal,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════════
  // LABEL - Метки и кнопки (Crimson Pro)
  // ═══════════════════════════════════════════════════════════════
  static TextStyle get labelLarge => GoogleFonts.crimsonPro(
    fontSize: size16,
    fontWeight: semibold,
    letterSpacing: 0.5,
  );

  static TextStyle get labelMedium => GoogleFonts.crimsonPro(
    fontSize: size14,
    fontWeight: medium,
    letterSpacing: 0.25,
  );

  static TextStyle get labelSmall => GoogleFonts.crimsonPro(
    fontSize: size12,
    fontWeight: medium,
    letterSpacing: 0.25,
  );

  // ═══════════════════════════════════════════════════════════════
  // СПЕЦИАЛЬНЫЕ СТИЛИ
  // ═══════════════════════════════════════════════════════════════
  
  /// Стиль для таймера - крупный и выразительный
  static TextStyle get timerDisplay => GoogleFonts.playfairDisplay(
    fontSize: 72,
    fontWeight: bold,
    letterSpacing: 2,
  );

  /// Стиль для цитат и акцентного текста
  static TextStyle get quote => GoogleFonts.playfairDisplay(
    fontSize: size20,
    fontWeight: normal,
    fontStyle: FontStyle.italic,
    height: 1.6,
  );

  /// Стиль для чисел и статистики
  static TextStyle get statNumber => GoogleFonts.crimsonPro(
    fontSize: size32,
    fontWeight: bold,
  );
}
