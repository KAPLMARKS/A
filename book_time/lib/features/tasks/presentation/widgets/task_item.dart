import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/task.dart';

/// Элемент книги/задачи в стиле книжной закладки
class TaskItem extends StatelessWidget {
  final Task task;
  final bool isActive;
  final VoidCallback onToggled;
  final VoidCallback onDeleted;
  final VoidCallback onActivated;

  const TaskItem({
    super.key,
    required this.task,
    required this.isActive,
    required this.onToggled,
    required this.onDeleted,
    required this.onActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.accentPrimary
              : AppColors.glassBorder,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.glowPrimary,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Декоративная "закладка" слева
            Container(
              width: 6,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isActive
                      ? [AppColors.accentPrimary, AppColors.accentSecondary]
                      : task.isCompleted
                          ? [AppColors.successGreen, AppColors.successGreen.withOpacity(0.5)]
                          : [AppColors.accentCopper.withOpacity(0.5), AppColors.accentCopper.withOpacity(0.2)],
                ),
              ),
            ),
            // Основной контент
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Иконка книги/чтения
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive 
                            ? AppColors.accentPrimary.withOpacity(0.2)
                            : task.isCompleted
                                ? AppColors.successGreen.withOpacity(0.15)
                                : AppColors.cardBgLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? AppColors.accentPrimary.withOpacity(0.3)
                              : AppColors.glassBorder,
                        ),
                      ),
                      child: Icon(
                        task.isCompleted 
                            ? Icons.check_circle_rounded
                            : isActive 
                                ? Icons.auto_stories_rounded
                                : Icons.menu_book_rounded,
                        color: isActive
                            ? AppColors.accentPrimary
                            : task.isCompleted
                                ? AppColors.successGreen
                                : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Текст задачи
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: AppFonts.titleMedium.copyWith(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: task.isCompleted
                                  ? AppColors.textTertiary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${task.estimatedSessions} ${task.estimatedSessions == 1 ? 'session' : 'sessions'}',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPrimary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.accentPrimary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bookmark_rounded,
                                        size: 10,
                                        color: AppColors.accentPrimary,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Reading',
                                        style: AppFonts.labelSmall.copyWith(
                                          color: AppColors.accentPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Кнопки действий
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Кнопка завершения
                        IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.replay_rounded
                                : Icons.check_circle_outline_rounded,
                          ),
                          onPressed: onToggled,
                          color: task.isCompleted
                              ? AppColors.textSecondary
                              : AppColors.successGreen,
                          tooltip: task.isCompleted ? 'Reopen' : 'Mark as finished',
                          iconSize: 24,
                        ),
                        // Кнопка активации
                        if (!task.isCompleted && !isActive)
                          IconButton(
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            onPressed: onActivated,
                            color: AppColors.accentPrimary,
                            tooltip: 'Start reading',
                            iconSize: 24,
                          ),
                        // Кнопка удаления
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: onDeleted,
                          color: AppColors.errorRed.withOpacity(0.8),
                          tooltip: 'Remove from list',
                          iconSize: 22,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
