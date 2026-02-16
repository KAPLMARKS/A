import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Бар еженедельной активности чтения в книжном стиле
class WeeklyActivityBar extends StatelessWidget {
  final String day;
  final int minutes;
  final double height;
  final bool hasActivity;

  const WeeklyActivityBar({
    super.key,
    required this.day,
    required this.minutes,
    required this.height,
    required this.hasActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: height),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animatedHeight, child) {
                return Container(
                  width: double.infinity,
                  height: animatedHeight,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    gradient: hasActivity
                        ? const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.accentCopper,
                              AppColors.accentPrimary,
                              AppColors.accentGold,
                            ],
                          )
                        : null,
                    color: hasActivity ? null : AppColors.cardBgLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasActivity 
                          ? AppColors.accentGold.withOpacity(0.3)
                          : AppColors.glassBorder,
                      width: 1,
                    ),
                    boxShadow: hasActivity
                        ? [
                            BoxShadow(
                              color: AppColors.accentGold.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: hasActivity && animatedHeight > 20
                      ? Center(
                          child: Icon(
                            Icons.auto_stories_rounded,
                            size: 12,
                            color: AppColors.scaffoldBg.withOpacity(0.7),
                          ),
                        )
                      : null,
                );
              },
            ),
            Text(
              day,
              style: AppFonts.labelSmall.copyWith(
                color: hasActivity 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              minutes > 0 ? '${minutes}m' : '-',
              style: AppFonts.labelSmall.copyWith(
                color: hasActivity
                    ? AppColors.accentGold
                    : AppColors.textTertiary,
                fontSize: 10,
                fontWeight: hasActivity ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
