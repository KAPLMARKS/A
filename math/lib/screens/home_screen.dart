import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../services/app_logger.dart';
import '../services/statistics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/category_card.dart';
import '../widgets/difficulty_bottom_sheet.dart';
import 'exercise_screen.dart';
import 'statistics_screen.dart';

/// Главный экран приложения.
///
/// Отображает сетку категорий упражнений,
/// краткую статистику и навигацию к детальной статистике.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tag = 'HomeScreen';

  void _onCategoryTap(BuildContext context, ExerciseCategory category) async {
    AppLogger.info('Выбрана категория: ${category.label}', tag: _tag);

    final difficulty = await DifficultyBottomSheet.show(
      context,
      category: category,
    );

    if (difficulty == null || !context.mounted) return;

    AppLogger.info(
      'Начало сессии: ${category.label}, ${difficulty.label}',
      tag: _tag,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseScreen(
          category: category,
          difficulty: difficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = StatisticsService();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Заголовок
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Математика',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Выберите категорию для тренировки',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StatisticsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bar_chart_rounded),
                          tooltip: 'Статистика',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary.withAlpha(25),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Мини-статистика
            if (stats.totalSessions > 0)
              SliverToBoxAdapter(
                child: _MiniStats(stats: stats),
              ),
            // Заголовок секции
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Text(
                  'Категории',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            // Сетка категорий
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = ExerciseCategory.values[index];
                    return CategoryCard(
                      category: category,
                      index: index,
                      onTap: () => _onCategoryTap(context, category),
                    );
                  },
                  childCount: ExerciseCategory.values.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStats extends StatelessWidget {
  final StatisticsService stats;

  const _MiniStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    final accuracy = (stats.overallAccuracy * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStatItem(
              icon: Icons.play_circle_outline,
              value: '${stats.totalSessions}',
              label: 'Сессий',
            ),
            _MiniStatItem(
              icon: Icons.check_circle_outline,
              value: '${stats.totalCorrect}',
              label: 'Правильных',
            ),
            _MiniStatItem(
              icon: Icons.percent,
              value: '$accuracy%',
              label: 'Точность',
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
