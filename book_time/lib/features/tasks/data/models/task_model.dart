import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.category,
    super.estimatedSessions,
    super.note,
    super.isCompleted,
    required super.createdAt,
    super.isActive,
    super.completedSessions,
  });

  factory TaskModel.fromJson(Map<String, Object?> json) {
    final categoryRaw = json['category'];
    final categoryName = categoryRaw is String ? categoryRaw : null;
    final estimatedRaw = json['estimatedSessions'];
    final estimatedSessions = estimatedRaw is num ? estimatedRaw.toInt() : 1;
    final completedRaw = json['completedSessions'];
    final completedSessions = completedRaw is num ? completedRaw.toInt() : 0;
    final isCompletedRaw = json['isCompleted'];
    final isCompleted = isCompletedRaw is bool ? isCompletedRaw : false;
    final isActiveRaw = json['isActive'];
    final isActive = isActiveRaw is bool ? isActiveRaw : false;
    final noteRaw = json['note'];
    final note = noteRaw is String ? noteRaw : null;

    return TaskModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      category: TaskCategory.values.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => TaskCategory.focus,
      ),
      estimatedSessions: estimatedSessions,
      note: note,
      isCompleted: isCompleted,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isActive: isActive,
      completedSessions: completedSessions,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'estimatedSessions': estimatedSessions,
      'note': note,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'completedSessions': completedSessions,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      isActive: task.isActive,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted,
      createdAt: createdAt,
      isActive: isActive,
    );
  }
}
