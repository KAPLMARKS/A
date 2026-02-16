import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/statistics.dart';
import '../utils/weekly_activity_helper.dart';
import 'weekly_activity_bar.dart';

/// График еженедельной активности чтения в книжном стиле
class WeeklyActivityChart extends StatelessWidget {
  final Statistics statistics;

  const WeeklyActivityChart({super.key, required this.statistics});

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
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: AppColors.accentSecondary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Reading This Week',
                style: AppFonts.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Minutes spent reading each day',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          _buildActivityBars(context),
        ],
      ),
    );
  }

  Widget _buildActivityBars(BuildContext context) {
    final weekData = statistics.weeklyActivity;
    final maxMinutes = WeeklyActivityHelper.getMaxMinutes(weekData);
    const maxHeight = 80.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: weekData.entries.map((entry) {
        final day = entry.key;
        final minutes = entry.value;
        final height = WeeklyActivityHelper.calculateBarHeight(
          minutes,
          maxMinutes,
          maxHeight,
        );
        final hasActivity = minutes > 0;

        return WeeklyActivityBar(
          day: day,
          minutes: minutes,
          height: height,
          hasActivity: hasActivity,
        );
      }).toList(),
    );
  }
}
