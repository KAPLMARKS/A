import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/exercise_result.dart';
import '../services/statistics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';

/// Экран детальной статистики.
///
/// Показывает общую статистику, разбивку по категориям
/// и историю последних сессий.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _stats = StatisticsService();

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Сбросить статистику?'),
        content: const Text(
          'Все данные о пройденных сессиях будут удалены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _stats.reset();
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text(
              'Сбросить',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: _stats.totalSessions == 0
          ? const _EmptyState()
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final accuracy = (_stats.overallAccuracy * 100).round();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Общая статистика
        Text(
          'Общий прогресс',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            StatCard(
              icon: Icons.play_circle_fill,
              iconColor: AppColors.primary,
              value: '${_stats.totalSessions}',
              label: 'Сессий пройдено',
            ),
            StatCard(
              icon: Icons.calculate,
              iconColor: AppColors.warning,
              value: '${_stats.totalExercises}',
              label: 'Задач решено',
            ),
            StatCard(
              icon: Icons.check_circle,
              iconColor: AppColors.success,
              value: '${_stats.totalCorrect}',
              label: 'Верных ответов',
            ),
            StatCard(
              icon: Icons.percent,
              iconColor: accuracy >= 70 ? AppColors.success : AppColors.error,
              value: '$accuracy%',
              label: 'Общая точность',
            ),
          ],
        ),
        const SizedBox(height: 32),
        // По категориям
        Text(
          'По категориям',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...ExerciseCategory.values.map(
          (cat) => _CategoryStatTile(
            category: cat,
            stats: _stats.statsForCategory(cat),
            bestAccuracy: _stats.bestAccuracy(cat),
          ),
        ),
        const SizedBox(height: 32),
        // Последние сессии
        if (_stats.sessions.isNotEmpty) ...[
          Text(
            'Последние сессии',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ..._stats.recentSessions(count: 10).reversed.map(
                (session) => _SessionTile(session: session),
              ),
        ],
        // Кнопка сброса
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: _confirmReset,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            label: const Text(
              'Сбросить статистику',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Пока нет данных',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Пройдите хотя бы одну сессию упражнений, '
              'чтобы увидеть статистику',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryStatTile extends StatelessWidget {
  final ExerciseCategory category;
  final CategoryStats stats;
  final double bestAccuracy;

  const _CategoryStatTile({
    required this.category,
    required this.stats,
    required this.bestAccuracy,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.sessionsPlayed == 0) {
      return const SizedBox.shrink();
    }

    final accuracy = (stats.accuracy * 100).round();
    final best = (bestAccuracy * 100).round();
    final gradient = AppColors.gradientForIndex(
      ExerciseCategory.values.indexOf(category),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                category.icon,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${stats.sessionsPlayed} сессий · '
                    '${stats.totalExercises} задач',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$accuracy%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accuracy >= 70 ? AppColors.success : AppColors.error,
                  ),
                ),
                Text(
                  'лучший: $best%',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final SessionResult session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final accuracy = (session.accuracy * 100).round();
    final date = session.completedAt;
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accuracy >= 70
                ? AppColors.success.withAlpha(25)
                : AppColors.error.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '$accuracy%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: accuracy >= 70 ? AppColors.success : AppColors.error,
            ),
          ),
        ),
        title: Text(
          '${session.category.label} · ${session.difficulty.label}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${session.correctCount}/${session.totalExercises} верно · $dateStr',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        dense: true,
      ),
    );
  }
}
