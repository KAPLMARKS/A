import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Кнопка управления таймером в магическом книжном стиле
class TimerControlButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TimerControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<TimerControlButton> createState() => _TimerControlButtonState();
}

class _TimerControlButtonState extends State<TimerControlButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  // Внешнее магическое свечение
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(
                      0.3 + (_glowController.value * 0.2),
                    ),
                    blurRadius: 20 + (_glowController.value * 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.accentGold.withOpacity(
                      0.15 + (_glowController.value * 0.1),
                    ),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                  // Тень
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentPrimary,
                      AppColors.accentSecondary,
                      AppColors.accentTertiary,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accentGold.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Иконка с свечением
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: AppColors.textPrimary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Текст
                    Text(
                      widget.label,
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
