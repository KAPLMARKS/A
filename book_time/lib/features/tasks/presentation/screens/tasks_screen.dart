import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/task_list.dart';
import '../widgets/create_task_bottom_sheet.dart';
import '../widgets/empty_tasks_state.dart';
import '../widgets/tasks_floating_action_button.dart';
import '../../domain/entities/task_category.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(const TasksLoaded());
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
              child: Column(
                children: [
                  // Заголовок в книжном стиле
                  _buildBookHeader(),
                  Expanded(
                    child: BlocBuilder<TasksBloc, TasksState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentPrimary,
                            ),
                          );
                        }

                        if (state.tasks.isEmpty) {
                          return EmptyTasksState(
                            onCreateTask: () => _showCreateTaskSheet(context),
                          );
                        }

                        return TaskList(
                          tasks: state.tasks,
                          activeTask: state.activeTask,
                          onTaskToggled: (taskId) {
                            context.read<TasksBloc>().add(TaskToggled(taskId));
                          },
                          onTaskDeleted: (taskId) {
                            context.read<TasksBloc>().add(TaskDeleted(taskId));
                          },
                          onTaskActivated: (taskId) {
                            context.read<TasksBloc>().add(TaskActivated(taskId));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TasksFloatingActionButton(
        onPressed: () => _showCreateTaskSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Декоративные элементы на фоне - магическое свечение библиотеки
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Верхнее свечение (свеча/лампа)
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentSecondary.withOpacity(0.12),
                  AppColors.accentSecondary.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Левое свечение
        Positioned(
          top: 300,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
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
        // Нижнее золотое свечение
        Positioned(
          bottom: 150,
          right: 50,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentGold.withOpacity(0.06),
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
                      AppColors.accentSecondary.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Иконка списка книг
              Icon(
                Icons.library_books_rounded,
                color: AppColors.accentSecondary,
                size: 28,
              ),
              const SizedBox(width: 12),
              // Название
              Text(
                'Reading List',
                style: AppFonts.headlineLarge.copyWith(
                  color: AppColors.textGold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.bookmark_rounded,
                color: AppColors.accentSecondary,
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
                      AppColors.accentSecondary.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Подзаголовок
          Text(
            'Your books and reading goals',
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskSheet(BuildContext context) {
    CreateTaskBottomSheet.show(
      context: context,
      onCreateTask:
          ({
            required String title,
            required TaskCategory category,
            required int estimatedSessions,
            String? note,
          }) {
            context.read<TasksBloc>().add(
              TaskAdded(
                title: title,
                category: category,
                estimatedSessions: estimatedSessions,
                note: note,
              ),
            );
          },
    );
  }

}
