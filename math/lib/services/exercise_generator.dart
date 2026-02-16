import 'dart:math' as math_lib;

import '../models/exercise.dart';
import 'app_logger.dart';

/// Генератор математических упражнений.
///
/// Создаёт упражнения по категории и уровню сложности
/// с корректными вариантами ответов (multiple choice).
class ExerciseGenerator {
  static const _tag = 'ExerciseGenerator';
  static final _random = math_lib.Random();

  ExerciseGenerator._();

  /// Количество упражнений в одной сессии
  static const int exercisesPerSession = 10;

  /// Количество вариантов ответа
  static const int optionsCount = 4;

  /// Генерация списка упражнений для сессии
  static List<Exercise> generateSession({
    required ExerciseCategory category,
    required Difficulty difficulty,
  }) {
    AppLogger.info(
      'Генерация сессии: категория=${category.label}, '
      'сложность=${difficulty.label}',
      tag: _tag,
    );

    try {
      final exercises = List.generate(
        exercisesPerSession,
        (_) => _generateExercise(category: category, difficulty: difficulty),
      );

      AppLogger.info(
        'Сессия сгенерирована: ${exercises.length} упражнений',
        tag: _tag,
      );
      return exercises;
    } catch (e, st) {
      AppLogger.error(
        'Ошибка генерации сессии',
        error: e,
        stackTrace: st,
        tag: _tag,
      );
      rethrow;
    }
  }

  /// Генерация вариантов ответа для упражнения
  static List<int> generateOptions(Exercise exercise) {
    final correct = exercise.correctAnswer;
    final options = <int>{correct};

    int attempts = 0;
    while (options.length < optionsCount && attempts < 100) {
      attempts++;
      final wrong = _generateWrongAnswer(correct, exercise.operation);
      if (wrong != correct) {
        options.add(wrong);
      }
    }

    // Если не удалось набрать 4 варианта — добавляем последовательные числа
    int fallback = 1;
    while (options.length < optionsCount) {
      if (!options.contains(correct + fallback)) {
        options.add(correct + fallback);
      }
      fallback++;
    }

    final result = options.toList()..shuffle(_random);
    return result;
  }

  static Exercise _generateExercise({
    required ExerciseCategory category,
    required Difficulty difficulty,
  }) {
    final operation = _operationForCategory(category);
    return _createExercise(operation: operation, difficulty: difficulty);
  }

  static Operation _operationForCategory(ExerciseCategory category) {
    return switch (category) {
      ExerciseCategory.addition => Operation.addition,
      ExerciseCategory.subtraction => Operation.subtraction,
      ExerciseCategory.multiplication => Operation.multiplication,
      ExerciseCategory.division => Operation.division,
      ExerciseCategory.mixed => Operation
          .values[_random.nextInt(Operation.values.length)],
    };
  }

  static Exercise _createExercise({
    required Operation operation,
    required Difficulty difficulty,
  }) {
    return switch (operation) {
      Operation.addition => _createAddition(difficulty),
      Operation.subtraction => _createSubtraction(difficulty),
      Operation.multiplication => _createMultiplication(difficulty),
      Operation.division => _createDivision(difficulty),
    };
  }

  static ({int min, int max}) _rangeForDifficulty(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => (min: 1, max: 10),
      Difficulty.medium => (min: 1, max: 50),
      Difficulty.hard => (min: 1, max: 100),
    };
  }

  static ({int min, int max}) _multRangeForDifficulty(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => (min: 1, max: 10),
      Difficulty.medium => (min: 2, max: 12),
      Difficulty.hard => (min: 2, max: 20),
    };
  }

  static int _randomInRange(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  static Exercise _createAddition(Difficulty difficulty) {
    final range = _rangeForDifficulty(difficulty);
    final a = _randomInRange(range.min, range.max);
    final b = _randomInRange(range.min, range.max);
    return Exercise(
      operand1: a,
      operand2: b,
      operation: Operation.addition,
      correctAnswer: a + b,
    );
  }

  static Exercise _createSubtraction(Difficulty difficulty) {
    final range = _rangeForDifficulty(difficulty);
    var a = _randomInRange(range.min, range.max);
    var b = _randomInRange(range.min, range.max);
    // Гарантируем неотрицательный результат
    if (a < b) {
      final temp = a;
      a = b;
      b = temp;
    }
    return Exercise(
      operand1: a,
      operand2: b,
      operation: Operation.subtraction,
      correctAnswer: a - b,
    );
  }

  static Exercise _createMultiplication(Difficulty difficulty) {
    final range = _multRangeForDifficulty(difficulty);
    final a = _randomInRange(range.min, range.max);
    final b = _randomInRange(range.min, range.max);
    return Exercise(
      operand1: a,
      operand2: b,
      operation: Operation.multiplication,
      correctAnswer: a * b,
    );
  }

  static Exercise _createDivision(Difficulty difficulty) {
    final range = _multRangeForDifficulty(difficulty);
    // Генерируем делитель и частное, потом вычисляем делимое
    final divisor = _randomInRange(range.min, range.max);
    final quotient = _randomInRange(range.min, range.max);
    final dividend = divisor * quotient;
    return Exercise(
      operand1: dividend,
      operand2: divisor,
      operation: Operation.division,
      correctAnswer: quotient,
    );
  }

  static int _generateWrongAnswer(int correct, Operation operation) {
    final offsetRange = switch (operation) {
      Operation.multiplication || Operation.division => 5,
      _ => 8,
    };

    final offset = _random.nextInt(offsetRange) + 1;
    final wrong = _random.nextBool() ? correct + offset : correct - offset;

    // Не допускаем отрицательных вариантов для простоты
    return wrong < 0 ? correct + offset : wrong;
  }
}
