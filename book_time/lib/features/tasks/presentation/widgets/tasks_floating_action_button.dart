import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Кнопка добавления книги в книжном стиле
class TasksFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TasksFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.library_add_rounded,
                  color: AppColors.scaffoldBg,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Add Book',
                  style: AppFonts.labelLarge.copyWith(
                    color: AppColors.scaffoldBg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
