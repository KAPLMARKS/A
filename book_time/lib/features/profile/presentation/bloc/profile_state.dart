import 'package:equatable/equatable.dart';
import '../../domain/entities/statistics.dart';
import '../../../tasks/domain/entities/task.dart';

class ProfileState extends Equatable {
  final Statistics statistics;
  final List<Task> tasks;
  final bool isLoading;

  const ProfileState({
    required this.statistics,
    this.tasks = const [],
    this.isLoading = false,
  });

  ProfileState copyWith({
    Statistics? statistics,
    List<Task>? tasks,
    bool? isLoading,
  }) {
    return ProfileState(
      statistics: statistics ?? this.statistics,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get todayFocusMinutes {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return statistics.dailyFocusMinutes[todayDate] ?? 0;
  }

  int get todaySessions {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final minutes = statistics.dailyFocusMinutes[todayDate] ?? 0;
    return minutes > 0 ? (minutes / 25).ceil() : 0;
  }

  @override
  List<Object?> get props => [statistics, tasks, isLoading];
}
