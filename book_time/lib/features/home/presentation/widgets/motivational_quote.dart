import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';
import '../utils/motivational_quotes_helper.dart';

/// Литературная цитата в стиле страницы из старинной книги
class MotivationalQuote extends StatefulWidget {
  const MotivationalQuote({super.key});

  @override
  State<MotivationalQuote> createState() => _MotivationalQuoteState();
}

class _MotivationalQuoteState extends State<MotivationalQuote> {
  late final Map<String, String> _quote;

  @override
  void initState() {
    super.initState();
    _quote = MotivationalQuotesHelper.getDailyQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Фон в виде старой бумаги
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBg,
            AppColors.cardBgLight.withOpacity(0.8),
            AppColors.cardBg,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowPrimary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Верхний декоративный элемент
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDecorativeLine(toRight: false),
              const SizedBox(width: 12),
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.accentPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              _buildDecorativeLine(toRight: true),
            ],
          ),
          const SizedBox(height: 16),
          
          // Кавычка открывающая
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '❝',
              style: TextStyle(
                fontSize: 32,
                color: AppColors.accentPrimary.withOpacity(0.5),
                height: 0.5,
              ),
            ),
          ),
          
          // Цитата
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _quote['text']!,
              style: AppFonts.quote.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Кавычка закрывающая
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '❞',
              style: TextStyle(
                fontSize: 32,
                color: AppColors.accentPrimary.withOpacity(0.5),
                height: 0.5,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Автор цитаты
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 1,
                color: AppColors.accentPrimary.withOpacity(0.3),
              ),
              const SizedBox(width: 12),
              Text(
                _quote['author']!,
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.accentPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 20,
                height: 1,
                color: AppColors.accentPrimary.withOpacity(0.3),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Нижний декоративный элемент
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.accentPrimary.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeLine({required bool toRight}) {
    return Container(
      width: 40,
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toRight
              ? [
                  AppColors.accentPrimary.withOpacity(0.5),
                  Colors.transparent,
                ]
              : [
                  Colors.transparent,
                  AppColors.accentPrimary.withOpacity(0.5),
                ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
