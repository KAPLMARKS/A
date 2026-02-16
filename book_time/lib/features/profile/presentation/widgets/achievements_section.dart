import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/statistics.dart';
import '../utils/achievements_helper.dart';
import 'achievement_badge.dart';

/// Секция достижений читателя в книжном стиле
class AchievementsSection extends StatelessWidget {
  final Statistics statistics;

  const AchievementsSection({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentGold.withOpacity(0.15),
                AppColors.accentPrimary.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentGold.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: AppColors.accentGold,
                size: 28,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading Achievements',
                    style: AppFonts.titleLarge.copyWith(
                      color: AppColors.textGold,
                    ),
                  ),
                  Text(
                    'Milestones on your reading journey',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAchievementsGrid(context),
      ],
    );
  }

  Widget _buildAchievementsGrid(BuildContext context) {
    final achievements = AchievementsHelper.getAchievements(statistics);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementBadge(achievement: achievements[index]);
      },
    );
  }
}
