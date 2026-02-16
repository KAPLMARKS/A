/// Математическая операция
enum Operation {
  addition,
  subtraction,
  multiplication,
  division;

  String get symbol {
    return switch (this) {
      Operation.addition => '+',
      Operation.subtraction => '−',
      Operation.multiplication => '×',
      Operation.division => '÷',
    };
  }

  String get label {
    return switch (this) {
      Operation.addition => 'Сложение',
      Operation.subtraction => 'Вычитание',
      Operation.multiplication => 'Умножение',
      Operation.division => 'Деление',
    };
  }
}

/// Уровень сложности
enum Difficulty {
  easy,
  medium,
  hard;

  String get label {
    return switch (this) {
      Difficulty.easy => 'Легко',
      Difficulty.medium => 'Средне',
      Difficulty.hard => 'Сложно',
    };
  }

  String get description {
    return switch (this) {
      Difficulty.easy => 'Числа от 1 до 10',
      Difficulty.medium => 'Числа от 1 до 50',
      Difficulty.hard => 'Числа от 1 до 100',
    };
  }
}

/// Категория упражнений
enum ExerciseCategory {
  addition,
  subtraction,
  multiplication,
  division,
  mixed;

  String get label {
    return switch (this) {
      ExerciseCategory.addition => 'Сложение',
      ExerciseCategory.subtraction => 'Вычитание',
      ExerciseCategory.multiplication => 'Умножение',
      ExerciseCategory.division => 'Деление',
      ExerciseCategory.mixed => 'Смешанные',
    };
  }

  String get description {
    return switch (this) {
      ExerciseCategory.addition => 'Тренировка сложения чисел',
      ExerciseCategory.subtraction => 'Тренировка вычитания чисел',
      ExerciseCategory.multiplication => 'Тренировка умножения чисел',
      ExerciseCategory.division => 'Тренировка деления чисел',
      ExerciseCategory.mixed => 'Все операции вперемешку',
    };
  }

  String get icon {
    return switch (this) {
      ExerciseCategory.addition => '+',
      ExerciseCategory.subtraction => '−',
      ExerciseCategory.multiplication => '×',
      ExerciseCategory.division => '÷',
      ExerciseCategory.mixed => '∑',
    };
  }
}

/// Математическое упражнение
class Exercise {
  final int operand1;
  final int operand2;
  final Operation operation;
  final int correctAnswer;

  const Exercise({
    required this.operand1,
    required this.operand2,
    required this.operation,
    required this.correctAnswer,
  });

  /// Текстовое представление упражнения
  String get displayText => '$operand1 ${operation.symbol} $operand2 = ?';

  @override
  String toString() =>
      '$operand1 ${operation.symbol} $operand2 = $correctAnswer';
}
