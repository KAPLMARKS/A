import 'package:equatable/equatable.dart';
import 'task_category.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final TaskCategory category;
  final int estimatedSessions;
  final String? note;
  final bool isCompleted;
  final DateTime createdAt;
  final bool isActive;
  final int completedSessions;

  const Task({
    required this.id,
    required this.title,
    this.category = TaskCategory.focus,
    this.estimatedSessions = 1,
    this.note,
    this.isCompleted = false,
    required this.createdAt,
    this.isActive = false,
    this.completedSessions = 0,
  });

  Task copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    int? estimatedSessions,
    String? note,
    bool? isCompleted,
    DateTime? createdAt,
    bool? isActive,
    int? completedSessions,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      estimatedSessions: estimatedSessions ?? this.estimatedSessions,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  double get progress {
    if (estimatedSessions == 0) return 0.0;
    return (completedSessions / estimatedSessions).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        estimatedSessions,
        note,
        isCompleted,
        createdAt,
        isActive,
        completedSessions,
      ];
}
