import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Табы режимов чтения в стиле книжных закладок
class TimerTabBar extends StatelessWidget {
  final TabController controller;

  const TimerTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TabBar(
          controller: controller,
          labelColor: AppColors.scaffoldBg,
          unselectedLabelColor: AppColors.textSecondary,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.accentPrimary,
                AppColors.accentSecondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPrimary.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          indicatorPadding: const EdgeInsets.all(4),
          labelStyle: AppFonts.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppFonts.labelMedium,
          tabs: [
            _buildTab('Read', Icons.auto_stories_rounded),
            _buildTab('Rest', Icons.visibility_off_rounded),
            _buildTab('Reflect', Icons.psychology_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
