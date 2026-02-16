import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Draws an animated river with flowing water, waves, lily-pads, and grassy banks.
class RiverPainter extends CustomPainter {
  final double gameTime;

  RiverPainter({required this.gameTime});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    const bankWidth = 26.0;
    final riverLeft = bankWidth;
    final riverRight = size.width - bankWidth;
    final riverWidth = riverRight - riverLeft;

    // ── Background grass ───────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = GameConstants.grassLight,
    );

    // ── River body ─────────────────────────────────────────
    final riverRect = Rect.fromLTRB(riverLeft, 0, riverRight, size.height);
    final riverGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [
        GameConstants.riverDeep,
        GameConstants.riverMid,
        GameConstants.riverLight,
        GameConstants.riverMid,
        GameConstants.riverDeep,
      ],
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
    );
    canvas.drawRect(
      riverRect,
      Paint()..shader = riverGradient.createShader(riverRect),
    );

    // ── Flowing current lines ──────────────────────────────
    _drawCurrentLines(canvas, size, riverLeft, riverRight);

    // ── Wave highlights ────────────────────────────────────
    _drawWaves(canvas, size, riverLeft, riverWidth);

    // ── Lily pads ──────────────────────────────────────────
    _drawLilyPads(canvas, size, riverLeft, riverWidth);

    // ── Water sparkles ─────────────────────────────────────
    _drawSparkles(canvas, size, riverLeft, riverWidth);

    // ── River banks ────────────────────────────────────────
    _drawBanks(canvas, size, bankWidth);

    // ── Reeds & grass tufts ────────────────────────────────
    _drawReeds(canvas, size, bankWidth);
  }

  void _drawCurrentLines(Canvas canvas, Size size, double left, double right) {
    final paint = Paint()
      ..color = GameConstants.riverFoam.withValues(alpha: 0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashLen = 20.0;
    const gapLen = 30.0;
    final speed = gameTime * 55;

    for (double xOff = 0.15; xOff < 0.9; xOff += 0.18) {
      final x = left + (right - left) * xOff;
      final phaseOffset = xOff * 200;
      double y = -(speed + phaseOffset) % (dashLen + gapLen);
      while (y < size.height) {
        final y1 = max(0.0, y);
        final y2 = min(size.height, y + dashLen);
        if (y2 > y1) {
          canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
        }
        y += dashLen + gapLen;
      }
    }
  }

  void _drawWaves(Canvas canvas, Size size, double left, double width) {
    final wavePaint = Paint()
      ..color = GameConstants.riverFoam.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int row = 0; row < (size.height / 60).ceil(); row++) {
      final baseY = row * 60.0 + (gameTime * 30) % 60;
      final path = Path();
      for (double dx = 0; dx <= width; dx += 2) {
        final waveY = baseY + sin((dx + gameTime * 80) * 0.04) * 5;
        if (dx == 0) {
          path.moveTo(left + dx, waveY);
        } else {
          path.lineTo(left + dx, waveY);
        }
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  void _drawLilyPads(Canvas canvas, Size size, double left, double width) {
    final rng = Random(42);
    final padPaint = Paint()..color = const Color(0xFF2E7D32).withValues(alpha: 0.35);
    final padStroke = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final baseX = left + rng.nextDouble() * width;
      final baseY = rng.nextDouble() * size.height;
      final padSize = 10.0 + rng.nextDouble() * 8;

      final drift = sin(gameTime * 0.5 + i * 1.3) * 4;
      final x = baseX + drift;
      final y = (baseY + gameTime * 12 + i * 120) % (size.height + 40) - 20;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(sin(gameTime * 0.3 + i) * 0.15);

      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: padSize, height: padSize * 0.7),
        padPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: padSize, height: padSize * 0.7),
        padStroke,
      );
      canvas.restore();
    }
  }

  void _drawSparkles(Canvas canvas, Size size, double left, double width) {
    final rng = Random(99);
    final sparklePaint = Paint()..color = Colors.white.withValues(alpha: 0.45);

    for (int i = 0; i < 14; i++) {
      final cx = left + rng.nextDouble() * width;
      final cy = rng.nextDouble() * size.height;
      final phase = rng.nextDouble() * pi * 2;
      final alpha = (sin(gameTime * 3 + phase) * 0.5 + 0.5).clamp(0.0, 1.0);

      if (alpha > 0.3) {
        canvas.drawCircle(
          Offset(cx, (cy + gameTime * 20 + i * 80) % size.height),
          1.5 + alpha * 1.5,
          sparklePaint..color = Colors.white.withValues(alpha: alpha * 0.5),
        );
      }
    }
  }

  void _drawBanks(Canvas canvas, Size size, double bankWidth) {
    final bankPaint = Paint();

    // Left bank gradient
    final leftRect = Rect.fromLTWH(0, 0, bankWidth + 4, size.height);
    bankPaint.shader = const LinearGradient(
      colors: [GameConstants.grassDark, GameConstants.bankBrown],
    ).createShader(leftRect);
    canvas.drawRect(Rect.fromLTWH(0, 0, bankWidth, size.height), Paint()..color = GameConstants.grassDark);
    canvas.drawRect(
      Rect.fromLTWH(bankWidth - 3, 0, 6, size.height),
      Paint()..color = GameConstants.bankBrown.withValues(alpha: 0.6),
    );

    // Right bank gradient
    canvas.drawRect(
      Rect.fromLTWH(size.width - bankWidth, 0, bankWidth, size.height),
      Paint()..color = GameConstants.grassDark,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width - bankWidth - 3, 0, 6, size.height),
      Paint()..color = GameConstants.bankBrown.withValues(alpha: 0.6),
    );
  }

  void _drawReeds(Canvas canvas, Size size, double bankWidth) {
    final reedPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (double y = 15; y < size.height; y += 35) {
      // Left side reeds
      final sway = sin(gameTime * 1.5 + y * 0.1) * 3;
      canvas.drawLine(
        Offset(bankWidth - 2, y + 12),
        Offset(bankWidth + 4 + sway, y - 4),
        reedPaint,
      );

      // Right side reeds
      final sway2 = sin(gameTime * 1.5 + y * 0.1 + 2) * 3;
      canvas.drawLine(
        Offset(size.width - bankWidth + 2, y + 12),
        Offset(size.width - bankWidth - 4 + sway2, y - 4),
        reedPaint,
      );
    }

    // Grass tufts on banks
    final tuftPaint = Paint()..color = const Color(0xFF388E3C);
    for (double y = 10; y < size.height; y += 28) {
      canvas.drawCircle(Offset(10, y), 4, tuftPaint);
      canvas.drawCircle(Offset(size.width - 10, y + 14), 4, tuftPaint);
    }
  }

  @override
  bool shouldRepaint(RiverPainter old) => true;
}
