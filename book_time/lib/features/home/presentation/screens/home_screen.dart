import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../domain/entities/timer_mode.dart';
import '../../../tasks/presentation/bloc/tasks_bloc.dart';
import '../../../tasks/presentation/bloc/tasks_state.dart';
import '../utils/timer_mode_helper.dart';
import '../utils/timer_control_helper.dart';
import '../widgets/animated_timer.dart';
import '../widgets/task_display.dart';
import '../widgets/motivational_quote.dart';
import '../widgets/timer_tab_bar.dart';
import '../widgets/timer_control_button.dart';

/// Главный экран приложения для чтения книг
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadActiveTask());
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final bloc = context.read<HomeBloc>();
    final newMode = TimerModeHelper.getModeFromTabIndex(_tabController.index);

    if (bloc.state.currentMode != newMode) {
      bloc.add(HomeTimerSkipped());
      Future.microtask(() {
        bloc.add(HomeModeChanged(newMode));
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Градиентный фон
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1923), // Тёмный верх
              Color(0xFF1A2634), // Сине-серый
              Color(0xFF0F1923), // Тёмный низ
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Декоративные магические элементы на фоне
            _buildBackgroundDecorations(),
            
            // Основной контент
            SafeArea(
              child: BlocListener<TasksBloc, TasksState>(
                listener: (context, tasksState) {
                  context.read<HomeBloc>().add(const HomeLoadActiveTask());
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    _syncTabController(state.currentMode);

                    return Column(
                      children: [
                        // Заголовок в книжном стиле
                        _buildBookHeader(state),
                        TimerTabBar(controller: _tabController),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                AnimatedTimer(
                                  formattedTime: state.formattedTime,
                                  progress: state.progress,
                                  isRunning: state.isRunning,
                                  modeLabel: state.currentMode.displayName,
                                ),
                                const SizedBox(height: 24),
                                // Описание текущего режима
                                _buildModeDescription(state),
                                const SizedBox(height: 24),
                                _buildTimerControls(context, state),
                                const SizedBox(height: 32),
                                TaskDisplay(activeTask: state.activeTask),
                                const SizedBox(height: 16),
                                const MotivationalQuote(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Декоративные элементы на фоне - магическое свечение библиотеки
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Верхнее свечение (свеча/лампа)
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentPrimary.withOpacity(0.15),
                  AppColors.accentPrimary.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Правое свечение
        Positioned(
          top: 200,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentSecondary.withOpacity(0.1),
                  AppColors.accentSecondary.withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Нижнее золотое свечение
        Positioned(
          bottom: 100,
          left: 50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentGold.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Заголовок в книжном стиле
  Widget _buildBookHeader(HomeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Левая декоративная линия
              Container(
                width: 30,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.accentPrimary.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Иконка книги
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.accentPrimary,
                size: 28,
              ),
              const SizedBox(width: 12),
              // Название
              Text(
                'Reading Time',
                style: AppFonts.headlineLarge.copyWith(
                  color: AppColors.textGold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.auto_stories_rounded,
                color: AppColors.accentPrimary,
                size: 28,
              ),
              const SizedBox(width: 12),
              // Правая декоративная линия
              Container(
                width: 30,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentPrimary.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Описание текущего режима
  Widget _buildModeDescription(HomeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.glassBorder,
        ),
      ),
      child: Text(
        state.currentMode.description,
        style: AppFonts.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void _syncTabController(TimerMode currentMode) {
    final currentIndex = TimerModeHelper.getTabIndex(currentMode);
    if (_tabController.index != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(currentIndex);
      });
    }
  }

  Widget _buildTimerControls(BuildContext context, HomeState state) {
    return TimerControlButton(
      icon: _getControlIcon(state),
      label: _getControlLabel(state),
      onPressed: () {
        TimerControlHelper.handleControlTap(
          state,
          () => context.read<HomeBloc>().add(const HomeTimerResumed()),
          () => context.read<HomeBloc>().add(const HomeTimerPaused()),
          () => context.read<HomeBloc>().add(const HomeTimerStarted()),
        );
      },
    );
  }

  /// Иконка кнопки управления в книжном контексте
  IconData _getControlIcon(HomeState state) {
    if (state.isPaused) {
      return Icons.play_arrow_rounded; // Продолжить
    } else if (state.isRunning) {
      if (state.currentMode == TimerMode.reading) {
        return Icons.bookmark_rounded; // Сделать закладку (пауза)
      } else if (state.currentMode == TimerMode.shortBreak) {
        return Icons.pause_rounded; // Пауза отдыха
      } else {
        return Icons.pause_rounded; // Пауза размышления
      }
    } else {
      if (state.currentMode == TimerMode.reading) {
        return Icons.auto_stories_rounded; // Начать читать
      } else if (state.currentMode == TimerMode.shortBreak) {
        return Icons.visibility_off_rounded; // Отдохнуть глазам
      } else {
        return Icons.psychology_rounded; // Размышлять
      }
    }
  }

  /// Текст кнопки управления в книжном контексте  
  String _getControlLabel(HomeState state) {
    if (state.isPaused) {
      if (state.currentMode == TimerMode.reading) {
        return 'Continue Reading';
      } else if (state.currentMode == TimerMode.shortBreak) {
        return 'Continue Resting';
      } else {
        return 'Continue Reflecting';
      }
    } else if (state.isRunning) {
      if (state.currentMode == TimerMode.reading) {
        return 'Bookmark';
      } else if (state.currentMode == TimerMode.shortBreak) {
        return 'Pause Rest';
      } else {
        return 'Pause Reflection';
      }
    } else {
      if (state.currentMode == TimerMode.reading) {
        return 'Start Reading';
      } else if (state.currentMode == TimerMode.shortBreak) {
        return 'Rest Eyes';
      } else {
        return 'Reflect';
      }
    }
  }
}
