import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../../tasks/domain/entities/task.dart';

/// Отображение текущей книги/главы в стиле закладки
class TaskDisplay extends StatelessWidget {
  final Task? activeTask;

  const TaskDisplay({
    super.key,
    this.activeTask,
  });

  @override
  Widget build(BuildContext context) {
    if (activeTask == null) {
      return _buildEmptyState(context);
    }

    return _buildActiveTask(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorder,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_rounded,
            color: AppColors.textTertiary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'No book selected',
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTask(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Основной контент
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardBg,
                  AppColors.cardBgLight,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentPrimary.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Иконка книги
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accentPrimary,
                        AppColors.accentSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentPrimary.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.scaffoldBg,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Информация о книге
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currently Reading',
                        style: AppFonts.labelSmall.copyWith(
                          color: AppColors.accentPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeTask!.title,
                        style: AppFonts.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (activeTask!.note != null && activeTask!.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          activeTask!.note!,
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // Прогресс чтения
                      if (activeTask!.estimatedSessions > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: activeTask!.progress,
                                  backgroundColor: AppColors.cardBgLight,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.accentPrimary,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${activeTask!.completedSessions}/${activeTask!.estimatedSessions}',
                              style: AppFonts.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Декоративный элемент
                Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.accentGold.withOpacity(0.4),
                  size: 32,
                ),
              ],
            ),
          ),
          
          // Декоративная лента-закладка сверху
          Positioned(
            top: 0,
            right: 24,
            child: Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
