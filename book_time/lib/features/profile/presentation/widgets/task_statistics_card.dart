import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/statistics.dart';
import '../../../tasks/domain/entities/task.dart';
import '../utils/task_statistics_helper.dart';
import 'stat_row.dart';

/// Карточка статистики по книгам в книжном стиле
class TaskStatisticsCard extends StatelessWidget {
  final Statistics statistics;
  final List<Task> tasks;

  const TaskStatisticsCard({
    super.key,
    required this.statistics,
    required this.tasks,
  });

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
                Icons.library_books_rounded,
                color: AppColors.accentCopper,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Book Statistics',
                style: AppFonts.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your reading progress overview',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatisticsRows(context),
        ],
      ),
    );
  }

  Widget _buildStatisticsRows(BuildContext context) {
    final completedTasks = TaskStatisticsHelper.getCompletedTasksCount(tasks);
    final totalEstimatedSessions =
        TaskStatisticsHelper.getTotalEstimatedSessions(tasks);
    final mostFocusedCategory = TaskStatisticsHelper.getMostFocusedCategory(
      tasks,
    );

    return Column(
      children: [
        StatRow(
          icon: Icons.check_circle_rounded,
          label: 'Books Finished',
          value: '$completedTasks',
          color: AppColors.successGreen,
        ),
        const SizedBox(height: 16),
        StatRow(
          icon: Icons.schedule_rounded,
          label: 'Reading Sessions',
          value: '$totalEstimatedSessions',
          color: AppColors.accentPrimary,
        ),
        const SizedBox(height: 16),
        StatRow(
          icon: mostFocusedCategory?.icon ?? Icons.category_rounded,
          label: 'Favorite Genre',
          value: mostFocusedCategory?.displayName ?? 'None',
          color: AppColors.accentSecondary,
        ),
      ],
    );
  }
}
