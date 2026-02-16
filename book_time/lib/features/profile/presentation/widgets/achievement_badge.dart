import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/achievement.dart';

/// Бейдж достижения в книжном стиле
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const AchievementBadge({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: achievement.isUnlocked
            ? LinearGradient(
                colors: [
                  AppColors.accentGold.withOpacity(0.15),
                  AppColors.accentPrimary.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: achievement.isUnlocked ? null : AppColors.cardBgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.accentGold
              : AppColors.glassBorder,
          width: achievement.isUnlocked ? 2 : 1,
        ),
        boxShadow: achievement.isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.accentGold.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? AppColors.accentGold.withOpacity(0.2)
                  : AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.isUnlocked 
                  ? Icons.auto_stories_rounded 
                  : Icons.lock_outline_rounded,
              color: achievement.isUnlocked
                  ? AppColors.accentGold
                  : AppColors.textTertiary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: AppFonts.labelMedium.copyWith(
                color: achievement.isUnlocked
                    ? AppColors.textGold
                    : AppColors.textTertiary,
                fontWeight: achievement.isUnlocked
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
