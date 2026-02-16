import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/user_summary_card.dart';
import '../widgets/focus_level_card.dart';
import '../widgets/weekly_activity_chart.dart';
import '../widgets/task_statistics_card.dart';
import '../widgets/achievements_section.dart';
import '../../../tasks/presentation/bloc/tasks_bloc.dart';
import '../../../tasks/presentation/bloc/tasks_state.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileStatisticsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Магический градиентный фон библиотеки
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
                  context.read<ProfileBloc>().add(const ProfileRefreshRequested());
                },
                child: BlocListener<HomeBloc, HomeState>(
                  listener: (context, homeState) {
                    context.read<ProfileBloc>().add(const ProfileRefreshRequested());
                  },
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentPrimary,
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProfileBloc>().add(const ProfileStatisticsLoaded());
                        },
                        color: AppColors.accentPrimary,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Заголовок в книжном стиле
                              _buildBookHeader(),
                              const SizedBox(height: 20),
                              UserSummaryCard(statistics: state.statistics),
                              const SizedBox(height: 20),
                              FocusLevelCard(statistics: state.statistics),
                              const SizedBox(height: 20),
                              WeeklyActivityChart(statistics: state.statistics),
                              const SizedBox(height: 20),
                              TaskStatisticsCard(
                                statistics: state.statistics,
                                tasks: state.tasks,
                              ),
                              const SizedBox(height: 20),
                              AchievementsSection(statistics: state.statistics),
                              const SizedBox(height: 20),
                              _buildResetButton(context),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
        // Верхнее свечение
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentGold.withOpacity(0.12),
                  AppColors.accentGold.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Правое свечение
        Positioned(
          top: 250,
          right: -70,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentPrimary.withOpacity(0.1),
                  AppColors.accentPrimary.withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Нижнее свечение
        Positioned(
          bottom: 200,
          left: 30,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentSecondary.withOpacity(0.08),
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
  Widget _buildBookHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка дневника читателя
              Icon(
                Icons.history_edu_rounded,
                color: AppColors.accentGold,
                size: 26,
              ),
              const SizedBox(width: 10),
              // Название
              Flexible(
                child: Text(
                  'Reader\'s Journal',
                  style: AppFonts.headlineLarge.copyWith(
                    color: AppColors.textGold,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.local_library_rounded,
                color: AppColors.accentGold,
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Подзаголовок
          Text(
            'Your reading journey & achievements',
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.errorRed.withOpacity(0.3),
          ),
        ),
        child: TextButton(
          onPressed: () => _showResetDialog(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.errorRed,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restart_alt_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Reset Reading Stats',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: AppColors.errorRed,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Reset Journal',
              style: AppFonts.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to reset all your reading statistics? Your reading journey will start fresh. This action cannot be undone.',
          style: AppFonts.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Keep Stats',
              style: AppFonts.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.errorRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                profileBloc.add(const ProfileStatisticsReset());
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Reset',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
