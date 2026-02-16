import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../../domain/entities/task_category.dart';

/// Bottom sheet для добавления новой книги в книжном стиле
class CreateTaskBottomSheet extends StatefulWidget {
  final Function({
    required String title,
    required TaskCategory category,
    required int estimatedSessions,
    String? note,
  })
  onCreateTask;

  const CreateTaskBottomSheet({super.key, required this.onCreateTask});

  static Future<void> show({
    required BuildContext context,
    required Function({
      required String title,
      required TaskCategory category,
      required int estimatedSessions,
      String? note,
    })
    onCreateTask,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: CreateTaskBottomSheet(onCreateTask: onCreateTask),
      ),
    );
  }

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TaskCategory _selectedCategory = TaskCategory.focus;
  int _selectedSessions = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      widget.onCreateTask(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        estimatedSessions: _selectedSessions,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onCategorySelected(TaskCategory category) {
    if (_selectedCategory != category) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  void _onSessionsSelected(int sessions) {
    if (_selectedSessions != sessions) {
      setState(() {
        _selectedSessions = sessions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.5, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: _BottomSheetDecoration(),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  const _DragHandle(),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24),
                        physics: const ClampingScrollPhysics(),
                        children: [
                          _Header(),
                          const SizedBox(height: 32),
                          _TitleField(controller: _titleController),
                          const SizedBox(height: 24),
                          _CategorySelector(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: _onCategorySelected,
                          ),
                          const SizedBox(height: 24),
                          _SessionsSelector(
                            selectedSessions: _selectedSessions,
                            onSessionsSelected: _onSessionsSelected,
                          ),
                          const SizedBox(height: 24),
                          _NoteField(controller: _noteController),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  _SubmitButton(onSubmit: _handleSubmit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomSheetDecoration extends BoxDecoration {
  _BottomSheetDecoration()
    : super(
        color: AppColors.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glowPrimary,
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      );
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textTertiary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentPrimary.withOpacity(0.3),
                AppColors.accentSecondary.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentPrimary.withOpacity(0.3)),
          ),
          child: const Icon(
            Icons.library_add_rounded,
            color: AppColors.accentPrimary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Book',
                style: AppFonts.headlineMedium.copyWith(
                  color: AppColors.textGold,
                ),
              ),
              Text(
                'Expand your reading list',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Book Title *',
              style: AppFonts.titleMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          autofocus: true,
          style: AppFonts.bodyLarge.copyWith(color: AppColors.textPrimary),
          maxLength: 100,
          decoration: _InputDecoration(hintText: 'Enter book title...'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Book title is required';
            }
            if (value.trim().length < 3) {
              return 'Book title must be at least 3 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final TaskCategory selectedCategory;
  final ValueChanged<TaskCategory> onCategorySelected;

  const _CategorySelector({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Reading Goal',
              style: AppFonts.titleMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: TaskCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryItem(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(category),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final TaskCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPrimary.withOpacity(0.2)
              : AppColors.cardBgLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentPrimary : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              category.icon,
              color: isSelected
                  ? AppColors.accentPrimary
                  : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              category.displayName,
              style: AppFonts.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.accentPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionsSelector extends StatelessWidget {
  final int selectedSessions;
  final ValueChanged<int> onSessionsSelected;

  const _SessionsSelector({
    required this.selectedSessions,
    required this.onSessionsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Reading Sessions',
              style: AppFonts.titleMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'How many reading sessions to finish this book?',
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            final sessions = index + 1;
            final isSelected = selectedSessions == sessions;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 4 ? 8 : 0),
                child: _SessionItem(
                  sessions: sessions,
                  isSelected: isSelected,
                  onTap: () => onSessionsSelected(sessions),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SessionItem extends StatelessWidget {
  final int sessions;
  final bool isSelected;
  final VoidCallback onTap;

  const _SessionItem({
    required this.sessions,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentSecondary.withOpacity(0.2)
              : AppColors.cardBgLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.accentSecondary
                : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          '$sessions',
          textAlign: TextAlign.center,
          style: AppFonts.labelLarge.copyWith(
            color: isSelected
                ? AppColors.accentSecondary
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  final TextEditingController controller;

  const _NoteField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.note_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Notes (Optional)',
              style: AppFonts.titleMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Author, genre, or why you want to read it',
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          maxLines: 3,
          maxLength: 200,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: _InputDecoration(hintText: 'Add notes about this book...'),
        ),
      ],
    );
  }
}

class _InputDecoration extends InputDecoration {
  _InputDecoration({required String hintText})
    : super(
        hintText: hintText,
        hintStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.cardBgLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const _SubmitButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPrimary.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.scaffoldBg,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.library_add_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Add to Library',
                  style: AppFonts.labelLarge.copyWith(
                    color: AppColors.scaffoldBg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
