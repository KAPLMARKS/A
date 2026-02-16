import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'bottom_navigation_ui_constants.dart';

class NavigationColors {
  NavigationColors._();

  static const Color selectedIconColor = AppColors.accentPrimary;
  static const Color unselectedIconColor = AppColors.textSecondary;

  static Color getSelectedGlowColor() => AppColors.accentPrimary.withValues(
        alpha: BottomNavigationUIConstants.selectedGlowOpacity,
      );

  static Color getUnselectedGlowColor() => AppColors.textSecondary.withValues(
        alpha: BottomNavigationUIConstants.unselectedIconOpacity,
      );

  static Color getGlassGlowColor() => AppColors.accentPrimary.withValues(
        alpha: BottomNavigationUIConstants.glassGlowOpacity,
      );

  static Color getIndicatorShadowColor() => AppColors.accentPrimary.withValues(
        alpha: BottomNavigationUIConstants.indicatorShadowOpacity,
      );

  static Color getContainerShadowColor() => Colors.black.withValues(
        alpha: BottomNavigationUIConstants.shadowOpacity,
      );

  static Color getBorderColor(bool isDark) {
    if (isDark) {
      return AppColors.accentPrimary.withValues(
        alpha: BottomNavigationUIConstants.borderOpacity,
      );
    } else {
      return AppColors.accentPrimary.withValues(
        alpha: BottomNavigationUIConstants.borderOpacityLight,
      );
    }
  }

  static double getBorderWidth(bool isDark) {
    return isDark
        ? BottomNavigationUIConstants.borderWidth
        : BottomNavigationUIConstants.borderWidthLight;
  }

  static Color getGlassColor(bool isDark) => AppColors.accentPrimary.withValues(
        alpha: isDark
            ? BottomNavigationUIConstants.glassColorOpacityDark
            : BottomNavigationUIConstants.glassColorOpacityLight,
      );
}

