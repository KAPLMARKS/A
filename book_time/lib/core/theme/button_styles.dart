import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_border_radius.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Стили кнопок для приложения Book Time
/// Холодные бирюзовые тона

// ═══════════════════════════════════════════════════════════════
// ОСНОВНАЯ КНОПКА - Янтарный акцент
// ═══════════════════════════════════════════════════════════════
ButtonStyle primaryButtonStyle({double radius = AppBorderRadius.md}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.accentPrimary.withOpacity(0.4);
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.accentSecondary;
        }
        return AppColors.accentPrimary;
      },
    ),
    foregroundColor: WidgetStateProperty.all(AppColors.scaffoldBg),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (states) => states.contains(WidgetState.pressed)
          ? AppColors.scaffoldBg.withOpacity(0.1)
          : null,
    ),
    elevation: WidgetStateProperty.resolveWith<double>(
      (states) => states.contains(WidgetState.pressed) ? 2.0 : 0.0,
    ),
    shadowColor: WidgetStateProperty.all<Color>(AppColors.glowPrimary),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(AppFonts.labelLarge),
  );
}

// ═══════════════════════════════════════════════════════════════
// ВТОРИЧНАЯ КНОПКА - С обводкой
// ═══════════════════════════════════════════════════════════════
ButtonStyle secondaryButtonStyle({double radius = AppBorderRadius.md}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.accentPrimary.withOpacity(0.1);
        }
        return Colors.transparent;
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.accentPrimary.withOpacity(0.4);
        }
        return AppColors.accentPrimary;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.accentPrimary, width: 1.5),
      ),
    ),
    overlayColor: WidgetStateProperty.all(AppColors.glowPrimary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(AppFonts.labelLarge),
  );
}

// ═══════════════════════════════════════════════════════════════
// ЗОЛОТАЯ КНОПКА - Премиум стиль с градиентом
// ═══════════════════════════════════════════════════════════════
ButtonStyle goldButtonStyle({double radius = AppBorderRadius.md}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.accentGold.withOpacity(0.4);
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.accentCopper;
        }
        return AppColors.accentGold;
      },
    ),
    foregroundColor: WidgetStateProperty.all(AppColors.scaffoldBg),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    elevation: WidgetStateProperty.resolveWith<double>(
      (states) => states.contains(WidgetState.pressed) ? 4.0 : 2.0,
    ),
    shadowColor: WidgetStateProperty.all<Color>(AppColors.glowSecondary),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(AppFonts.labelLarge),
  );
}

// ═══════════════════════════════════════════════════════════════
// СТЕКЛЯННАЯ КНОПКА - Glass morphism
// ═══════════════════════════════════════════════════════════════
ButtonStyle glassButtonStyle({double radius = AppBorderRadius.md}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.glassBg.withOpacity(0.4);
        }
        return AppColors.glassBg;
      },
    ),
    foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.glassBorder, width: 1),
      ),
    ),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(AppFonts.labelLarge),
  );
}

// ═══════════════════════════════════════════════════════════════
// КНОПКА DANGER - Для опасных действий
// ═══════════════════════════════════════════════════════════════
ButtonStyle dangerButtonStyle({double radius = AppBorderRadius.md}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.errorRed.withOpacity(0.4);
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.errorRed.withOpacity(0.8);
        }
        return AppColors.errorRed;
      },
    ),
    foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(AppFonts.labelLarge),
  );
}

// ═══════════════════════════════════════════════════════════════
// ICON BUTTON STYLE - Для кнопок с иконками
// ═══════════════════════════════════════════════════════════════
ButtonStyle iconButtonStyle({double size = 48}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.glowPrimary;
        }
        return Colors.transparent;
      },
    ),
    foregroundColor: WidgetStateProperty.all(AppColors.accentPrimary),
    shape: WidgetStateProperty.all(const CircleBorder()),
    minimumSize: WidgetStateProperty.all(Size(size, size)),
    padding: WidgetStateProperty.all(EdgeInsets.zero),
    overlayColor: WidgetStateProperty.all(AppColors.glowPrimary),
  );
}
