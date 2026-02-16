import 'package:flutter/material.dart';

import '../models/exercise_result.dart';
import '../theme/app_colors.dart';

/// Элемент списка результатов.
///
/// Показывает упражнение, ответ пользователя и правильный ответ.
class ResultListItem extends StatelessWidget {
  final ExerciseResult result;
  final int index;

  const ResultListItem({
    super.key,
    required this.result,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = result.exercise;
    final isCorrect = result.isCorrect;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withAlpha(15)
            : AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? AppColors.success.withAlpha(60)
              : AppColors.error.withAlpha(60),
        ),
      ),
      child: Row(
        children: [
          // Номер
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isCorrect ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Упражнение
          Expanded(
            child: Text(
              '${exercise.operand1} ${exercise.operation.symbol} ${exercise.operand2}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Ответ пользователя
          if (!result.isSkipped)
            Text(
              '= ${result.userAnswer}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCorrect ? AppColors.success : AppColors.error,
                decoration: isCorrect ? null : TextDecoration.lineThrough,
              ),
            ),
          if (!isCorrect) ...[
            const SizedBox(width: 8),
            Text(
              '= ${exercise.correctAnswer}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ],
          const SizedBox(width: 8),
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? AppColors.success : AppColors.error,
            size: 22,
          ),
        ],
      ),
    );
  }
}
