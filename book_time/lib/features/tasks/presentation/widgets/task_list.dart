import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/task.dart';
import '../utils/tasks_helper.dart';
import 'task_item.dart';

/// Список книг для чтения в книжном стиле
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Task? activeTask;
  final Function(String) onTaskToggled;
  final Function(String) onTaskDeleted;
  final Function(String) onTaskActivated;

  const TaskList({
    super.key,
    required this.tasks,
    this.activeTask,
    required this.onTaskToggled,
    required this.onTaskDeleted,
    required this.onTaskActivated,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _buildCurrentlyReadingSection(context),
        _buildToReadSection(context),
        _buildFinishedBooksSection(context),
      ],
    );
  }

  /// Секция "Сейчас читаю"
  Widget _buildCurrentlyReadingSection(BuildContext context) {
    if (activeTask == null || activeTask!.isCompleted) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.auto_stories_rounded,
          title: 'Currently Reading',
          color: AppColors.accentPrimary,
        ),
        const SizedBox(height: 12),
        TaskItem(
          task: activeTask!,
          isActive: true,
          onToggled: () => onTaskToggled(activeTask!.id),
          onDeleted: () => onTaskDeleted(activeTask!.id),
          onActivated: () => onTaskActivated(activeTask!.id),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Секция "Хочу прочитать"
  Widget _buildToReadSection(BuildContext context) {
    final toReadTasks = TasksHelper.getIncompleteTasks(tasks)
        .where((task) => activeTask == null || task.id != activeTask!.id)
        .toList();

    if (toReadTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.bookmark_border_rounded,
          title: 'To Read',
          color: AppColors.accentSecondary,
        ),
        const SizedBox(height: 12),
        ...toReadTasks.map(
          (task) => TaskItem(
            task: task,
            isActive: false,
            onToggled: () => onTaskToggled(task.id),
            onDeleted: () => onTaskDeleted(task.id),
            onActivated: () => onTaskActivated(task.id),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Секция "Прочитанные книги"
  Widget _buildFinishedBooksSection(BuildContext context) {
    final completedTasks = TasksHelper.getCompletedTasks(tasks);

    if (completedTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.check_circle_rounded,
          title: 'Finished Books',
          color: AppColors.successGreen,
        ),
        const SizedBox(height: 12),
        ...completedTasks.map(
          (task) => TaskItem(
            task: task,
            isActive: false,
            onToggled: () => onTaskToggled(task.id),
            onDeleted: () => onTaskDeleted(task.id),
            onActivated: () {},
          ),
        ),
      ],
    );
  }

  /// Заголовок секции в книжном стиле
  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppFonts.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
