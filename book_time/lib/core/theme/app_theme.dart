import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_border_radius.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Тема приложения Book Time
/// Холодный сине-бирюзовый стиль
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    brightness: Brightness.dark,
    useMaterial3: true,
    
    // ═══════════════════════════════════════════════════════════════
    // ЦВЕТОВАЯ СХЕМА
    // ═══════════════════════════════════════════════════════════════
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      secondary: AppColors.accentSecondary,
      tertiary: AppColors.accentTertiary,
      surface: AppColors.cardBg,
      error: AppColors.errorRed,
      onPrimary: AppColors.scaffoldBg,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textPrimary,
      outline: AppColors.glassBorder,
    ),

    // ═══════════════════════════════════════════════════════════════
    // APP BAR
    // ═══════════════════════════════════════════════════════════════
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: AppFonts.headlineMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // КАРТОЧКИ
    // ═══════════════════════════════════════════════════════════════
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 0,
      shadowColor: AppColors.glowPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        side: const BorderSide(color: AppColors.glassBorder, width: 1),
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // РАЗДЕЛИТЕЛИ
    // ═══════════════════════════════════════════════════════════════
    dividerTheme: const DividerThemeData(
      color: AppColors.textTertiary,
      thickness: 1,
    ),

    // ═══════════════════════════════════════════════════════════════
    // ИКОНКИ
    // ═══════════════════════════════════════════════════════════════
    iconTheme: const IconThemeData(
      color: AppColors.accentPrimary,
      size: 24,
    ),

    // ═══════════════════════════════════════════════════════════════
    // КНОПКИ
    // ═══════════════════════════════════════════════════════════════
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.scaffoldBg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: AppFonts.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        side: const BorderSide(color: AppColors.accentPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: AppFonts.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        textStyle: AppFonts.labelMedium,
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // FAB
    // ═══════════════════════════════════════════════════════════════
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentPrimary,
      foregroundColor: AppColors.scaffoldBg,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // ═══════════════════════════════════════════════════════════════
    // INPUT DECORATION
    // ═══════════════════════════════════════════════════════════════
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.accentPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
      labelStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
      hintStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textTertiary),
    ),

    // ═══════════════════════════════════════════════════════════════
    // ЧЕКБОКСЫ И ПЕРЕКЛЮЧАТЕЛИ
    // ═══════════════════════════════════════════════════════════════
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentPrimary;
        }
        return AppColors.cardBg;
      }),
      checkColor: WidgetStateProperty.all(AppColors.scaffoldBg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentPrimary;
        }
        return AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentPrimary.withOpacity(0.3);
        }
        return AppColors.cardBgLight;
      }),
    ),

    // ═══════════════════════════════════════════════════════════════
    // ПРОГРЕСС ИНДИКАТОРЫ
    // ═══════════════════════════════════════════════════════════════
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accentPrimary,
      linearTrackColor: AppColors.cardBgLight,
      circularTrackColor: AppColors.cardBgLight,
    ),

    // ═══════════════════════════════════════════════════════════════
    // СЛАЙДЕРЫ
    // ═══════════════════════════════════════════════════════════════
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.accentPrimary,
      inactiveTrackColor: AppColors.cardBgLight,
      thumbColor: AppColors.accentPrimary,
      overlayColor: AppColors.glowPrimary,
      valueIndicatorColor: AppColors.accentPrimary,
      valueIndicatorTextStyle: AppFonts.labelSmall.copyWith(
        color: AppColors.scaffoldBg,
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // BOTTOM NAVIGATION
    // ═══════════════════════════════════════════════════════════════
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBg,
      selectedItemColor: AppColors.accentPrimary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: AppFonts.labelSmall,
      unselectedLabelStyle: AppFonts.labelSmall,
    ),

    // ═══════════════════════════════════════════════════════════════
    // NAVIGATION BAR (Material 3)
    // ═══════════════════════════════════════════════════════════════
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.cardBg,
      indicatorColor: AppColors.glowPrimary,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.accentPrimary);
        }
        return const IconThemeData(color: AppColors.textTertiary);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppFonts.labelSmall.copyWith(color: AppColors.accentPrimary);
        }
        return AppFonts.labelSmall.copyWith(color: AppColors.textTertiary);
      }),
    ),

    // ═══════════════════════════════════════════════════════════════
    // SNACKBAR
    // ═══════════════════════════════════════════════════════════════
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardBgLight,
      contentTextStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ═══════════════════════════════════════════════════════════════
    // ДИАЛОГИ
    // ═══════════════════════════════════════════════════════════════
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardBg,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      titleTextStyle: AppFonts.headlineMedium.copyWith(color: AppColors.textPrimary),
      contentTextStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
    ),

    // ═══════════════════════════════════════════════════════════════
    // BOTTOM SHEET
    // ═══════════════════════════════════════════════════════════════
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardBg,
      modalBackgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ═══════════════════════════════════════════════════════════════
    // ТЕКСТОВЫЕ СТИЛИ
    // ═══════════════════════════════════════════════════════════════
    textTheme: TextTheme(
      displayLarge: AppFonts.displayLarge.copyWith(color: AppColors.textPrimary),
      displayMedium: AppFonts.displayMedium.copyWith(color: AppColors.textPrimary),
      displaySmall: AppFonts.displaySmall.copyWith(color: AppColors.textPrimary),
      headlineLarge: AppFonts.headlineLarge.copyWith(color: AppColors.textPrimary),
      headlineMedium: AppFonts.headlineMedium.copyWith(color: AppColors.textPrimary),
      headlineSmall: AppFonts.headlineSmall.copyWith(color: AppColors.textPrimary),
      titleLarge: AppFonts.titleLarge.copyWith(color: AppColors.textPrimary),
      titleMedium: AppFonts.titleMedium.copyWith(color: AppColors.textPrimary),
      titleSmall: AppFonts.titleSmall.copyWith(color: AppColors.textPrimary),
      bodyLarge: AppFonts.bodyLarge.copyWith(color: AppColors.textSecondary),
      bodyMedium: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
      bodySmall: AppFonts.bodySmall.copyWith(color: AppColors.textTertiary),
      labelLarge: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
      labelMedium: AppFonts.labelMedium.copyWith(color: AppColors.textSecondary),
      labelSmall: AppFonts.labelSmall.copyWith(color: AppColors.textTertiary),
    ),
  );
}
