import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/statistics.dart';

/// Карточка уровня читателя в книжном стиле
class FocusLevelCard extends StatelessWidget {
  final Statistics statistics;

  const FocusLevelCard({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowPrimary,
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    color: AppColors.accentGold,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Reader Level',
                    style: AppFonts.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.accentGold,
                      AppColors.accentPrimary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 16,
                      color: AppColors.scaffoldBg,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lvl ${statistics.level}',
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.scaffoldBg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getReaderRank(),
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          // Прогресс-бар с книжным стилем
          Stack(
            children: [
              // Фон
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.cardBgLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.glassBorder,
                  ),
                ),
              ),
              // Прогресс
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: statistics.levelProgress),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, child) {
                    return FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentGold,
                              AppColors.accentPrimary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (progress > 0.15) ...[
                                Icon(
                                  Icons.bookmark_rounded,
                                  size: 14,
                                  color: AppColors.scaffoldBg,
                                ),
                                const SizedBox(width: 4),
                              ],
                              if (progress > 0.25)
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: AppFonts.labelSmall.copyWith(
                                    color: AppColors.scaffoldBg,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 16,
                    color: AppColors.accentGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${statistics.xp} XP',
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${statistics.xpForNextLevel} XP',
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'to Level ${statistics.level + 1}',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getReaderRank() {
    final level = statistics.level;
    if (level >= 20) return 'You\'ve mastered the art of reading!';
    if (level >= 15) return 'A true scholar of literature';
    if (level >= 10) return 'Books are your best friends';
    if (level >= 5) return 'Growing your reading habit';
    if (level >= 2) return 'Starting your reading journey';
    return 'Every great reader starts somewhere';
  }
}
