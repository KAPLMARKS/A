import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';

/// Нижняя шторка выбора сложности.
///
/// Показывает три варианта сложности с описанием.
/// Возвращает выбранный [Difficulty] через Navigator.pop.
class DifficultyBottomSheet extends StatelessWidget {
  final ExerciseCategory category;

  const DifficultyBottomSheet({super.key, required this.category});

  /// Показать шторку и получить выбранную сложность
  static Future<Difficulty?> show(
    BuildContext context, {
    required ExerciseCategory category,
  }) {
    return showModalBottomSheet<Difficulty>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DifficultyBottomSheet(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Индикатор шторки
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            category.label,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите уровень сложности',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...Difficulty.values.map(
            (difficulty) => _DifficultyTile(
              difficulty: difficulty,
              onTap: () => Navigator.pop(context, difficulty),
            ),
          ),
          SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
        ],
      ),
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  final Difficulty difficulty;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (difficulty) {
      Difficulty.easy => (Icons.sentiment_satisfied_alt, AppColors.success),
      Difficulty.medium => (Icons.sentiment_neutral, AppColors.warning),
      Difficulty.hard => (Icons.local_fire_department, AppColors.error),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        difficulty.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        difficulty.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
