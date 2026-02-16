import 'dart:async';

import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/exercise_result.dart';
import '../services/app_logger.dart';
import '../services/exercise_generator.dart';
import '../theme/app_colors.dart';
import '../widgets/answer_option.dart';
import '../widgets/progress_header.dart';
import 'result_screen.dart';

/// Экран прохождения упражнений.
///
/// Показывает по одному упражнению с 4 вариантами ответа.
/// После ответа — короткая пауза с обратной связью,
/// затем автопереход к следующему вопросу.
class ExerciseScreen extends StatefulWidget {
  final ExerciseCategory category;
  final Difficulty difficulty;

  const ExerciseScreen({
    super.key,
    required this.category,
    required this.difficulty,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  static const _tag = 'ExerciseScreen';

  late final List<Exercise> _exercises;
  late final List<List<int>> _allOptions;
  final List<ExerciseResult> _results = [];

  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _isShowingFeedback = false;

  final Stopwatch _sessionStopwatch = Stopwatch();
  final Stopwatch _questionStopwatch = Stopwatch();
  Timer? _timerUpdater;
  Duration _elapsedDisplay = Duration.zero;

  @override
  void initState() {
    super.initState();
    _exercises = ExerciseGenerator.generateSession(
      category: widget.category,
      difficulty: widget.difficulty,
    );
    _allOptions = _exercises
        .map((e) => ExerciseGenerator.generateOptions(e))
        .toList();
    _sessionStopwatch.start();
    _questionStopwatch.start();
    _startTimerUpdater();
    AppLogger.info('Сессия начата', tag: _tag);
  }

  @override
  void dispose() {
    _timerUpdater?.cancel();
    _sessionStopwatch.stop();
    _questionStopwatch.stop();
    super.dispose();
  }

  void _startTimerUpdater() {
    _timerUpdater = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsedDisplay = _sessionStopwatch.elapsed;
        });
      }
    });
  }

  void _onAnswerSelected(int answer) {
    if (_isShowingFeedback) return;

    _questionStopwatch.stop();
    final exercise = _exercises[_currentIndex];

    final result = ExerciseResult(
      exercise: exercise,
      userAnswer: answer,
      timeTaken: _questionStopwatch.elapsed,
    );
    _results.add(result);

    AppLogger.debug(
      'Ответ: $answer, правильно: ${exercise.correctAnswer}, '
      'верно: ${result.isCorrect}',
      tag: _tag,
    );

    setState(() {
      _selectedAnswer = answer;
      _isShowingFeedback = true;
    });

    // Пауза для показа обратной связи
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _moveToNext();
    });
  }

  void _moveToNext() {
    if (_currentIndex + 1 >= _exercises.length) {
      _finishSession();
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _isShowingFeedback = false;
    });
    _questionStopwatch
      ..reset()
      ..start();
  }

  void _finishSession() {
    _sessionStopwatch.stop();
    _timerUpdater?.cancel();

    final sessionResult = SessionResult(
      results: _results,
      category: widget.category,
      difficulty: widget.difficulty,
      completedAt: DateTime.now(),
    );

    AppLogger.info(
      'Сессия завершена: ${sessionResult.correctCount}/${sessionResult.totalExercises}',
      tag: _tag,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: sessionResult),
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выйти?'),
        content: const Text('Текущий прогресс будет потерян.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[_currentIndex];
    final options = _allOptions[_currentIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit,
          ),
          title: Text(widget.category.label),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                ProgressHeader(
                  current: _currentIndex + 1,
                  total: _exercises.length,
                  elapsed: _elapsedDisplay,
                ),
                const Spacer(flex: 2),
                // Упражнение
                _ExerciseDisplay(exercise: exercise),
                const Spacer(flex: 2),
                // Варианты ответа
                _OptionsGrid(
                  options: options,
                  correctAnswer: exercise.correctAnswer,
                  selectedAnswer: _selectedAnswer,
                  isShowingFeedback: _isShowingFeedback,
                  onSelect: _onAnswerSelected,
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseDisplay({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${exercise.operand1} ${exercise.operation.symbol} ${exercise.operand2}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '= ?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w300,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  final List<int> options;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool isShowingFeedback;
  final ValueChanged<int> onSelect;

  const _OptionsGrid({
    required this.options,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isShowingFeedback,
    required this.onSelect,
  });

  AnswerState _stateForOption(int option) {
    if (!isShowingFeedback) return AnswerState.idle;

    if (option == selectedAnswer) {
      return option == correctAnswer
          ? AnswerState.correct
          : AnswerState.wrong;
    }
    if (option == correctAnswer) {
      return AnswerState.revealed;
    }
    return AnswerState.idle;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: options.map((option) {
          return AnswerOption(
            value: option,
            state: _stateForOption(option),
            onTap: () => onSelect(option),
          );
        }).toList(),
      ),
    );
  }
}
