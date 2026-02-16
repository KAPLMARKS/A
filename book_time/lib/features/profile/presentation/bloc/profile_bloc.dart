import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_time/features/profile/domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../../tasks/domain/repositories/tasks_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StatisticsRepository statisticsRepository;
  final TasksRepository tasksRepository;

  ProfileBloc({
    required this.statisticsRepository,
    required this.tasksRepository,
  }) : super(ProfileState(statistics: const Statistics())) {
    on<ProfileStatisticsLoaded>(_onStatisticsLoaded);
    on<ProfileStatisticsReset>(_onStatisticsReset);
    on<ProfileRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStatisticsLoaded(
    ProfileStatisticsLoaded event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final statistics = await statisticsRepository.getStatistics();
      final tasks = await tasksRepository.getTasks();
      
      emit(state.copyWith(
        statistics: statistics,
        tasks: tasks,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final statistics = await statisticsRepository.getStatistics();
      final tasks = await tasksRepository.getTasks();
      
      emit(state.copyWith(
        statistics: statistics,
        tasks: tasks,
      ));
    } catch (_) {
      // Silent fail for auto-refresh
    }
  }

  Future<void> _onStatisticsReset(
    ProfileStatisticsReset event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await statisticsRepository.resetStatistics();
      final statistics = await statisticsRepository.getStatistics();
      final tasks = await tasksRepository.getTasks();
      emit(state.copyWith(statistics: statistics, tasks: tasks));
    } catch (_) {
      // Error handling
    }
  }
}
