import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/statistics.dart';
import '../utils/statistics_extensions.dart';
import '../utils/statistics_formatters.dart';
import 'metric_item.dart';

/// Карточка профиля читателя в книжном стиле
class UserSummaryCard extends StatelessWidget {
  final Statistics statistics;

  const UserSummaryCard({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentGold.withOpacity(0.12),
            AppColors.accentPrimary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentGold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowSecondary,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Аватар читателя с книжной тематикой
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.accentGold, AppColors.accentPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_library_rounded,
              color: AppColors.scaffoldBg,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          // Статус читателя
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentGold.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 16,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 6),
                Text(
                  _getReaderTitle(),
                  style: AppFonts.labelMedium.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            StatisticsFormatters.getDailyStatus(statistics),
            style: AppFonts.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildMetricsRow(context),
        ],
      ),
    );
  }

  String _getReaderTitle() {
    final level = statistics.level;
    if (level >= 20) return 'Master Librarian';
    if (level >= 15) return 'Scholar';
    if (level >= 10) return 'Bookworm';
    if (level >= 5) return 'Avid Reader';
    if (level >= 2) return 'Book Lover';
    return 'Aspiring Reader';
  }

  Widget _buildMetricsRow(BuildContext context) {
    final todayMinutes = statistics.getTodayMinutes();
    final todaySessions = statistics.getTodaySessions();
    final focusTime = StatisticsFormatters.formatFocusTime(todayMinutes);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MetricItem(
            value: todaySessions.toString(),
            label: 'Today',
            icon: Icons.menu_book_rounded,
          ),
          Container(width: 1, height: 40, color: AppColors.glassBorder),
          MetricItem(
            value: focusTime,
            label: 'Reading',
            icon: Icons.schedule_rounded,
          ),
          Container(width: 1, height: 40, color: AppColors.glassBorder),
          MetricItem(
            value: '${statistics.currentStreak}',
            label: 'Streak',
            icon: Icons.local_fire_department_rounded,
          ),
        ],
      ),
    );
  }
}
