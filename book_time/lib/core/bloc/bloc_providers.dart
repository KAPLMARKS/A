import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../navigation/presentation/cubit/navigation_cubit.dart';
import '../navigation/presentation/widgets/app_router.dart';
import '../navigation/data/constants/navigation_constants.dart';
import '../services/storage_service.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/data/datasources/tasks_local_datasource.dart';
import '../../features/profile/domain/repositories/statistics_repository.dart';
import '../../features/profile/data/repositories/statistics_repository_impl.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

final GetIt getIt = GetIt.instance;

class BlocProviders {
  BlocProviders._();

  static void setup() {
    _registerTalker();
    _registerNavigationCubit();
    _registerStorageService();
    _registerRepositories();
    _registerHomeBloc();
    _registerTasksBloc();
    _registerProfileBloc();
  }

  static void _registerTalker() {
    getIt.registerLazySingleton<Talker>(
      () => TalkerFlutter.init(settings: TalkerSettings(enabled: true)),
    );
  }

  static void _registerNavigationCubit() {
    getIt.registerFactoryParam<NavigationCubit, String, bool>(
      (currentLocation, isDark) =>
          NavigationCubit(currentLocation: currentLocation, isDark: isDark),
    );
  }

  static void _registerStorageService() {
    getIt.registerLazySingleton<StorageService>(
      () => StorageService(),
    );
  }

  static void _registerRepositories() {
    getIt.registerLazySingleton<TasksLocalDataSource>(
      () => TasksLocalDataSourceImpl(getIt<StorageService>()),
    );
    
    getIt.registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(getIt<TasksLocalDataSource>()),
    );
    
    getIt.registerLazySingleton<StatisticsRepository>(
      () => StatisticsRepositoryImpl(getIt<StorageService>()),
    );
  }

  static void _registerHomeBloc() {
    getIt.registerLazySingleton<HomeBloc>(
      () => HomeBloc(
        tasksRepository: getIt<TasksRepository>(),
        statisticsRepository: getIt<StatisticsRepository>(),
      ),
    );
  }

  static void _registerTasksBloc() {
    getIt.registerLazySingleton<TasksBloc>(
      () => TasksBloc(
        tasksRepository: getIt<TasksRepository>(),
        statisticsRepository: getIt<StatisticsRepository>(),
      ),
    );
  }

  static void _registerProfileBloc() {
    getIt.registerLazySingleton<ProfileBloc>(
      () => ProfileBloc(
        statisticsRepository: getIt<StatisticsRepository>(),
        tasksRepository: getIt<TasksRepository>(),
      ),
    );
  }

  static Widget wrapWithProviders({
    required BuildContext context,
    required Widget child,
  }) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    String currentLocation;
    try {
      currentLocation =
          AppRouter.router.routerDelegate.currentConfiguration.uri.path;
      if (currentLocation.isEmpty) {
        currentLocation = NavigationConstants.home;
      }
    } catch (_) {
      currentLocation = NavigationConstants.home;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (_) =>
              getIt<NavigationCubit>(param1: currentLocation, param2: isDark),
        ),
        BlocProvider<HomeBloc>.value(
          value: getIt<HomeBloc>(),
        ),
        BlocProvider<TasksBloc>.value(
          value: getIt<TasksBloc>(),
        ),
        BlocProvider<ProfileBloc>.value(
          value: getIt<ProfileBloc>(),
        ),
      ],
      child: child,
    );
  }
}
