import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:book_time/core/theme/app_colors.dart';
import 'package:book_time/core/theme/app_fonts.dart';

/// Анимированный таймер в магическом книжном стиле
/// С золотой рамкой и мистическим свечением
class AnimatedTimer extends StatefulWidget {
  final String formattedTime;
  final double progress;
  final bool isRunning;
  final String modeLabel;

  const AnimatedTimer({
    super.key,
    required this.formattedTime,
    required this.progress,
    required this.isRunning,
    required this.modeLabel,
  });

  @override
  State<AnimatedTimer> createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !oldWidget.isRunning) {
      _pulseController.repeat(reverse: true);
      _glowController.repeat(reverse: true);
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glowController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _calculateScale(),
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Магическое внешнее свечение
              boxShadow: [
                if (widget.isRunning) ...[
                  // Основное янтарное свечение
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(
                      0.3 + (_glowController.value * 0.2),
                    ),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                  // Золотое свечение
                  BoxShadow(
                    color: AppColors.accentGold.withOpacity(
                      0.15 + (_glowController.value * 0.1),
                    ),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ] else ...[
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Внешняя декоративная рамка (книжный орнамент)
                _buildOrnamentRing(),
                
                // Прогресс-кольцо
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CustomPaint(
                    painter: _MagicTimerProgressPainter(
                      progress: widget.progress,
                      isRunning: widget.isRunning,
                      glowValue: _glowController.value,
                    ),
                  ),
                ),
                
                // Внутренний круг с контентом
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBg,
                    border: Border.all(
                      color: AppColors.accentPrimary.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Иконка песочных часов (маленькая)
                        Icon(
                          Icons.hourglass_top_rounded,
                          color: AppColors.accentPrimary.withOpacity(0.6),
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        // Время
                        Text(
                          widget.formattedTime,
                          style: AppFonts.timerDisplay.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 52,
                            shadows: widget.isRunning
                                ? [
                                    Shadow(
                                      color: AppColors.accentPrimary
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Режим
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentPrimary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accentPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.modeLabel,
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.accentPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Декоративное кольцо в книжном стиле
  Widget _buildOrnamentRing() {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: _OrnamentRingPainter(
          isRunning: widget.isRunning,
          animationValue: _glowController.value,
        ),
      ),
    );
  }

  double _calculateScale() {
    return widget.isRunning ? 1.0 + (_pulseController.value * 0.02) : 1.0;
  }
}

/// Рисует магическое прогресс-кольцо
class _MagicTimerProgressPainter extends CustomPainter {
  final double progress;
  final bool isRunning;
  final double glowValue;

  _MagicTimerProgressPainter({
    required this.progress,
    required this.isRunning,
    required this.glowValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 15;
    const strokeWidth = 8.0;

    // Фоновое кольцо
    final backgroundPaint = Paint()
      ..color = AppColors.cardBgLight.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Прогресс
    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      if (isRunning) {
        // Янтарно-золотой градиент
        final rect = Rect.fromCircle(center: center, radius: radius);
        final gradient = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + (2 * math.pi),
          colors: const [
            AppColors.accentGold,
            AppColors.accentPrimary,
            AppColors.accentSecondary,
            AppColors.accentPrimary,
            AppColors.accentGold,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          transform: const GradientRotation(-math.pi / 2),
        );
        progressPaint.shader = gradient.createShader(rect);
      } else {
        progressPaint.color = AppColors.textTertiary;
      }

      final sweepAngle = 2 * math.pi * progress;
      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);

      // Светящаяся точка на конце прогресса
      if (isRunning && progress > 0.01) {
        final endAngle = -math.pi / 2 + sweepAngle;
        final endPoint = Offset(
          center.dx + radius * math.cos(endAngle),
          center.dy + radius * math.sin(endAngle),
        );

        final glowPaint = Paint()
          ..color = AppColors.accentGold.withOpacity(0.6 + glowValue * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawCircle(endPoint, 6, glowPaint);

        final dotPaint = Paint()..color = AppColors.accentGold;
        canvas.drawCircle(endPoint, 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_MagicTimerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.glowValue != glowValue;
  }
}

/// Рисует декоративное кольцо с орнаментом
class _OrnamentRingPainter extends CustomPainter {
  final bool isRunning;
  final double animationValue;

  _OrnamentRingPainter({
    required this.isRunning,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Внешнее декоративное кольцо
    final ringPaint = Paint()
      ..color = AppColors.accentPrimary.withOpacity(
        isRunning ? 0.4 + animationValue * 0.2 : 0.2,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, ringPaint);

    // Декоративные точки по кругу (как на старинных часах)
    final dotCount = 12;
    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi * i / dotCount) - math.pi / 2;
      final dotRadius = i % 3 == 0 ? 4.0 : 2.0;
      final dotCenter = Offset(
        center.dx + (radius - 8) * math.cos(angle),
        center.dy + (radius - 8) * math.sin(angle),
      );

      final dotPaint = Paint()
        ..color = i % 3 == 0
            ? AppColors.accentGold.withOpacity(
                isRunning ? 0.8 + animationValue * 0.2 : 0.4,
              )
            : AppColors.accentPrimary.withOpacity(0.3);

      canvas.drawCircle(dotCenter, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_OrnamentRingPainter oldDelegate) {
    return oldDelegate.isRunning != isRunning ||
        oldDelegate.animationValue != animationValue;
  }
}
