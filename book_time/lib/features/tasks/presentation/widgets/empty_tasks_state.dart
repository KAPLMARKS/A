import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Пустое состояние списка книг в книжном стиле
class EmptyTasksState extends StatelessWidget {
  final VoidCallback onCreateTask;

  const EmptyTasksState({
    super.key,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Декоративная иконка пустой книжной полки
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glowPrimary,
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.library_books_rounded,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Your Library is Empty',
              style: AppFonts.headlineMedium.copyWith(
                color: AppColors.textGold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first book to start\nyour reading journey',
              style: AppFonts.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Кнопка добавления в книжном стиле
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentPrimary, AppColors.accentSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onCreateTask,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Add Your First Book',
                  style: AppFonts.labelLarge.copyWith(
                    color: AppColors.scaffoldBg,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.scaffoldBg,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Декоративная цитата
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.glassBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.accentGold.withOpacity(0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'A reader lives a thousand lives',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
