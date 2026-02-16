import 'package:flutter/material.dart';

import '../models/exercise_result.dart';
import '../services/statistics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/result_list_item.dart';
import 'exercise_screen.dart';

/// Экран результатов после завершения сессии.
///
/// Показывает оценку, статистику, список ответов
/// и кнопки для повтора/возврата домой.
class ResultScreen extends StatefulWidget {
  final SessionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    // Записываем результат в статистику
    StatisticsService().recordSession(widget.result);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.result.accuracy,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _retry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseScreen(
          category: widget.result.category,
          difficulty: widget.result.difficulty,
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final totalTime = result.totalTime;
    final timeStr =
        '${totalTime.inMinutes}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Заголовок с анимированным счётом
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    children: [
                      // Звёзды
                      _StarsRow(stars: result.starRating),
                      const SizedBox(height: 24),
                      // Круговой индикатор
                      AnimatedBuilder(
                        animation: _scoreAnimation,
                        builder: (context, child) {
                          return _ScoreCircle(
                            progress: _scoreAnimation.value,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _resultMessage(result.starRating),
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Мини-статистика
                      _ResultStats(
                        correct: result.correctCount,
                        wrong: result.wrongCount,
                        time: timeStr,
                      ),
                    ],
                  ),
                ),
              ),
              // Заголовок списка
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Text(
                    'Подробности',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              // Список ответов
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ResultListItem(
                      result: result.results[index],
                      index: index,
                    ),
                    childCount: result.results.length,
                  ),
                ),
              ),
              // Кнопки
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _goHome,
                          icon: const Icon(Icons.home),
                          label: const Text('Домой'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Ещё раз'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resultMessage(int stars) {
    return switch (stars) {
      5 => 'Превосходно!',
      4 => 'Отлично!',
      3 => 'Хорошо!',
      2 => 'Неплохо',
      1 => 'Можно лучше',
      _ => 'Попробуйте ещё раз',
    };
  }
}

class _StarsRow extends StatelessWidget {
  final int stars;

  const _StarsRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            index < stars ? Icons.star_rounded : Icons.star_border_rounded,
            color: index < stars ? AppColors.warning : Colors.grey[300],
            size: 36,
          ),
        );
      }),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final double progress;

  const _ScoreCircle({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();
    final color = progress >= 0.8
        ? AppColors.success
        : progress >= 0.5
            ? AppColors.warning
            : AppColors.error;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'точность',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultStats extends StatelessWidget {
  final int correct;
  final int wrong;
  final String time;

  const _ResultStats({
    required this.correct,
    required this.wrong,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatChip(
          icon: Icons.check_circle,
          color: AppColors.success,
          value: '$correct',
          label: 'Верно',
        ),
        _StatChip(
          icon: Icons.cancel,
          color: AppColors.error,
          value: '$wrong',
          label: 'Ошибки',
        ),
        _StatChip(
          icon: Icons.timer,
          color: AppColors.primary,
          value: time,
          label: 'Время',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
