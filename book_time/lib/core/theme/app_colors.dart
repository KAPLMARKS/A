import 'package:flutter/material.dart';

/// Цветовая палитра приложения Book Time
/// Холодный сине-бирюзовый стиль с глубоким тёмным фоном
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // ОСНОВНОЙ ФОН - Глубокие тёмно-синие тона
  // ═══════════════════════════════════════════════════════════════
  static const Color scaffoldBg = Color(0xFF0F1923); // Глубокий тёмно-синий
  static const Color cardBg = Color(0xFF1A2634); // Тёмный сине-серый
  static const Color cardBgLight = Color(0xFF223344); // Светлый сине-серый
  static const Color surfaceElevated = Color(0xFF2A3A4E); // Приподнятая поверхность

  // ═══════════════════════════════════════════════════════════════
  // АКЦЕНТНЫЕ ЦВЕТА - Бирюза, индиго, пурпур
  // ═══════════════════════════════════════════════════════════════
  static const Color accentPrimary = Color(0xFF4DD0E1); // Бирюзовый
  static const Color accentSecondary = Color(0xFF5C6BC0); // Индиго
  static const Color accentTertiary = Color(0xFF7E57C2); // Глубокий пурпур
  static const Color accentGold = Color(0xFF80DEEA); // Светлый циан
  static const Color accentCopper = Color(0xFF26C6DA); // Тёмный циан

  // ═══════════════════════════════════════════════════════════════
  // ЦВЕТА ТЕКСТА
  // ═══════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFE8EDF2); // Холодный белый
  static const Color textSecondary = Color(0xFF90A4AE); // Сине-серый
  static const Color textTertiary = Color(0xFF546E7A); // Приглушённый сине-серый
  static const Color textGold = Color(0xFF80CBC4); // Бирюзовый текст

  // ═══════════════════════════════════════════════════════════════
  // СТАТУСЫ - Success/Error/Warning
  // ═══════════════════════════════════════════════════════════════
  static const Color successGreen = Color(0xFF66BB6A); // Зелёный
  static const Color errorRed = Color(0xFFEF5350); // Красный
  static const Color warningAmber = Color(0xFFFFA726); // Оранжевый

  // ═══════════════════════════════════════════════════════════════
  // ЭФФЕКТЫ СВЕЧЕНИЯ
  // ═══════════════════════════════════════════════════════════════
  static const Color glowPrimary = Color(0x604DD0E1); // Бирюзовое свечение
  static const Color glowSecondary = Color(0x5080DEEA); // Циановое свечение
  static const Color glowAccent = Color(0x405C6BC0); // Индиго свечение
  static const Color glowWarm = Color(0x357E57C2); // Пурпурное сияние

  // ═══════════════════════════════════════════════════════════════
  // СТЕКЛЯННЫЙ ЭФФЕКТ - Glass morphism
  // ═══════════════════════════════════════════════════════════════
  static const Color glassBg = Color(0x201A2634); // Холодное стекло
  static const Color glassBorder = Color(0x3080CBC4); // Бирюзовая граница
  static const Color glassHighlight = Color(0x1580DEEA); // Циановый блик

  // ═══════════════════════════════════════════════════════════════
  // ГРАДИЕНТЫ
  // ═══════════════════════════════════════════════════════════════
  static const Color gradientStart = Color(0xFF4DD0E1); // Бирюза
  static const Color gradientMiddle = Color(0xFF5C6BC0); // Индиго
  static const Color gradientEnd = Color(0xFF7E57C2); // Пурпур

  // Готовые градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF80DEEA), Color(0xFF4DD0E1), Color(0xFF26C6DA)],
  );

  static const LinearGradient warmGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x004DD0E1), Color(0x404DD0E1), Color(0x004DD0E1)],
  );

  static const RadialGradient magicGlow = RadialGradient(
    colors: [Color(0x5080DEEA), Color(0x204DD0E1), Color(0x00000000)],
    radius: 0.8,
  );
}
