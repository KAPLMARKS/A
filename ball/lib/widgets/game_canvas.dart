import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/ball_model.dart';
import '../models/obstacle_model.dart';

/// Custom painter that renders the entire game scene.
class GameCanvasPainter extends CustomPainter {
  final BallModel ball;
  final List<ObstacleModel> obstacles;
  final (Offset start, Offset end)? dragLine;
  final int score;
  final bool showReady;

  GameCanvasPainter({
    required this.ball,
    required this.obstacles,
    this.dragLine,
    required this.score,
    this.showReady = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawObstacles(canvas);
    _drawTrail(canvas);
    _drawBall(canvas);
    _drawDragLine(canvas);
    if (showReady) {
      _drawReadyText(canvas, size);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(0, size.height),
        [
          GameConstants.backgroundColor,
          GameConstants.surfaceColor,
          const Color(0xFF0F3460),
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(Offset.zero & size, paint);

    // Subtle grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;
    const gridSpacing = 40.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawObstacles(Canvas canvas) {
    for (final obstacle in obstacles) {
      final rrect = RRect.fromRectAndRadius(
        obstacle.rect,
        const Radius.circular(7),
      );

      // Glow effect
      final glowPaint = Paint()
        ..color = obstacle.color.withValues(alpha: obstacle.wasHit ? 0.15 : 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(rrect.inflate(4), glowPaint);

      // Main body
      final obstaclePaint = Paint()
        ..color = obstacle.wasHit
            ? obstacle.color.withValues(alpha: 0.4)
            : obstacle.color;
      canvas.drawRRect(rrect, obstaclePaint);

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(rrect, highlightPaint);
    }
  }

  void _drawTrail(Canvas canvas) {
    final trail = ball.trail;
    if (trail.length < 2) return;

    for (int i = 1; i < trail.length; i++) {
      final t = i / trail.length;
      final alpha = (t * 0.6).clamp(0.0, 1.0);
      final radius = ball.radius * t * 0.7;

      final trailPaint = Paint()
        ..color = ball.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.5);

      canvas.drawCircle(trail[i], radius, trailPaint);
    }
  }

  void _drawBall(Canvas canvas) {
    final center = ball.position;
    final r = ball.radius;

    // Outer glow
    final glowPaint = Paint()
      ..color = ball.color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, r + 4, glowPaint);

    // Ball gradient
    final ballPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(center.dx - r * 0.3, center.dy - r * 0.3),
        r * 1.5,
        [
          Colors.white.withValues(alpha: 0.9),
          ball.color,
          ball.color.withValues(alpha: 0.7),
        ],
        [0.0, 0.4, 1.0],
      );
    canvas.drawCircle(center, r, ballPaint);

    // Specular highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawCircle(
      Offset(center.dx - r * 0.25, center.dy - r * 0.25),
      r * 0.25,
      highlightPaint,
    );
  }

  void _drawDragLine(Canvas canvas) {
    final line = dragLine;
    if (line == null) return;

    final (start, end) = line;
    final delta = end - start;
    if (delta.distance < 10) return;

    // Draw dotted line from ball in the opposite direction
    final direction = Offset(-delta.dx, -delta.dy);
    final normalized = direction / direction.distance;
    final lineEnd = ball.position +
        normalized * min(delta.distance * 2, 200);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Dashed line
    const dashLength = 8.0;
    const gapLength = 6.0;
    final path = Path();
    final totalDist = (lineEnd - ball.position).distance;
    var current = 0.0;
    while (current < totalDist) {
      final startPoint = ball.position + normalized * current;
      final endPoint = ball.position +
          normalized * min(current + dashLength, totalDist);
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(endPoint.dx, endPoint.dy);
      current += dashLength + gapLength;
    }
    canvas.drawPath(path, linePaint);

    // Arrow head
    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    const arrowSize = 8.0;
    final arrowTip = lineEnd;
    final arrowLeft = arrowTip -
        normalized * arrowSize +
        Offset(-normalized.dy, normalized.dx) * arrowSize * 0.5;
    final arrowRight = arrowTip -
        normalized * arrowSize -
        Offset(-normalized.dy, normalized.dx) * arrowSize * 0.5;
    final arrowPath = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowLeft.dx, arrowLeft.dy)
      ..lineTo(arrowRight.dx, arrowRight.dy)
      ..close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  void _drawReadyText(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Drag the ball to launch!',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.85,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant GameCanvasPainter oldDelegate) => true;
}
