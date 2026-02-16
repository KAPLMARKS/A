import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Состояние кнопки ответа
enum AnswerState { idle, correct, wrong, revealed }

/// Кнопка варианта ответа.
///
/// Поддерживает состояния: обычное, правильный ответ,
/// неправильный ответ и подсветка правильного.
class AnswerOption extends StatelessWidget {
  final int value;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.value,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, textColor) = switch (state) {
      AnswerState.idle => (
          Colors.white,
          Colors.grey[300]!,
          AppColors.textPrimary,
        ),
      AnswerState.correct => (
          AppColors.success.withAlpha(25),
          AppColors.success,
          AppColors.success,
        ),
      AnswerState.wrong => (
          AppColors.error.withAlpha(25),
          AppColors.error,
          AppColors.error,
        ),
      AnswerState.revealed => (
          AppColors.success.withAlpha(15),
          AppColors.success.withAlpha(130),
          AppColors.success,
        ),
    };

    final icon = switch (state) {
      AnswerState.correct => Icons.check_circle,
      AnswerState.wrong => Icons.cancel,
      AnswerState.revealed => Icons.check_circle_outline,
      _ => null,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: state == AnswerState.idle ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 24),
                  const SizedBox(width: 12),
                ],
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
