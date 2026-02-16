import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pipe_model.dart';
import '../services/game_service.dart';

/// Custom painter that renders the entire game world every frame.
class GamePainter extends CustomPainter {
  final GameService gameService;

  GamePainter(this.gameService);

  // Pre-defined cloud templates: (startFracX, fracY, sizeFrac, speedFrac)
  static const _clouds = [
    (0.00, 0.07, 1.00, 0.30),
    (0.28, 0.18, 0.70, 0.50),
    (0.55, 0.05, 0.85, 0.40),
    (0.14, 0.26, 0.55, 0.60),
    (0.72, 0.14, 0.90, 0.35),
    (0.42, 0.22, 0.50, 0.55),
    (0.88, 0.10, 0.75, 0.45),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (!gameService.isReady || size.isEmpty) return;
    _drawSky(canvas, size);
    _drawClouds(canvas, size);
    _drawPipes(canvas, size);
    _drawGround(canvas, size);
    _drawPlane(canvas);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;

  // ================================================================
  // Sky
  // ================================================================

  void _drawSky(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF87CEEB), Color(0xFF5DA3D9), Color(0xFFADD8F0)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Small sun circle in upper right
    final sunCenter = Offset(size.width * 0.82, size.height * 0.08);
    final sunRadius = 28.0 * gameService.config.scale;
    canvas.drawCircle(
      sunCenter,
      sunRadius,
      Paint()..color = const Color(0x60FFF176),
    );
    canvas.drawCircle(
      sunCenter,
      sunRadius * 0.7,
      Paint()..color = const Color(0x90FFEE58),
    );
  }

  // ================================================================
  // Clouds (parallax scrolling)
  // ================================================================

  void _drawClouds(Canvas canvas, Size size) {
    final t = gameService.totalTime;
    final s = gameService.config.scale;
    final period = size.width + 200.0;

    for (final (rx, ry, rs, sm) in _clouds) {
      final speed = gameService.config.cloudBaseSpeed * sm;
      final rawX = rx * period - t * speed;
      final x = _floorMod(rawX + 100.0, period) - 100.0;
      _drawCloudShape(canvas, Offset(x, ry * size.height), 38.0 * rs * s);
    }
  }

  void _drawCloudShape(Canvas canvas, Offset center, double r) {
    final paint = Paint()..color = const Color(0xBBFFFFFF);
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 2.2, height: r * 1.1), paint);
    canvas.drawOval(
      Rect.fromCenter(center: center + Offset(r * 0.7, -r * 0.25), width: r * 1.6, height: r * 0.9),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center + Offset(-r * 0.6, -r * 0.15), width: r * 1.4, height: r * 0.85),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center + Offset(r * 0.15, -r * 0.45), width: r * 1.3, height: r * 0.7),
      paint,
    );
  }

  // ================================================================
  // Pipes
  // ================================================================

  void _drawPipes(Canvas canvas, Size size) {
    for (final pipe in gameService.pipes) {
      _drawPipePair(canvas, pipe);
    }
  }

  void _drawPipePair(Canvas canvas, PipeModel pipe) {
    final cfg = gameService.config;
    const bodyDark = Color(0xFF2E7D32);
    const bodyLight = Color(0xFF66BB6A);
    const bodyMid = Color(0xFF43A047);

    final bodyGradient = LinearGradient(
      colors: const [bodyDark, bodyLight, bodyMid, bodyDark],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    // ---------- Top pipe ----------
    final topRect = Rect.fromLTRB(pipe.x, 0, pipe.rightEdge, pipe.topPipeBottom);
    canvas.drawRect(topRect, Paint()..shader = bodyGradient.createShader(topRect));
    canvas.drawRect(topRect, Paint()..color = bodyDark..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // Top cap
    final capH = cfg.pipeCapHeight;
    final capE = cfg.pipeCapExtrusion;
    final topCap = RRect.fromRectAndRadius(
      Rect.fromLTRB(pipe.x - capE, pipe.topPipeBottom - capH, pipe.rightEdge + capE, pipe.topPipeBottom),
      Radius.circular(4.0 * cfg.scale),
    );
    canvas.drawRRect(topCap, Paint()..shader = bodyGradient.createShader(topCap.outerRect));
    canvas.drawRRect(topCap, Paint()..color = bodyDark..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // ---------- Bottom pipe ----------
    final botRect = Rect.fromLTRB(pipe.x, pipe.bottomPipeTop, pipe.rightEdge, cfg.groundY);
    canvas.drawRect(botRect, Paint()..shader = bodyGradient.createShader(botRect));
    canvas.drawRect(botRect, Paint()..color = bodyDark..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // Bottom cap
    final botCap = RRect.fromRectAndRadius(
      Rect.fromLTRB(pipe.x - capE, pipe.bottomPipeTop, pipe.rightEdge + capE, pipe.bottomPipeTop + capH),
      Radius.circular(4.0 * cfg.scale),
    );
    canvas.drawRRect(botCap, Paint()..shader = bodyGradient.createShader(botCap.outerRect));
    canvas.drawRRect(botCap, Paint()..color = bodyDark..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  // ================================================================
  // Ground
  // ================================================================

  void _drawGround(Canvas canvas, Size size) {
    final cfg = gameService.config;
    final groundTop = cfg.groundY;

    // Brown earth base
    canvas.drawRect(
      Rect.fromLTRB(0, groundTop, size.width, size.height),
      Paint()..color = const Color(0xFF8D6E63),
    );

    // Scrolling stripes
    final sw = cfg.groundStripeWidth;
    final offset = gameService.groundScrollOffset % (sw * 2);
    final stripePaint = Paint()..color = const Color(0xFF795548);
    for (double x = -offset - sw * 2; x < size.width + sw * 2; x += sw * 2) {
      canvas.drawRect(
        Rect.fromLTRB(x, groundTop + cfg.groundGrassHeight, x + sw, size.height),
        stripePaint,
      );
    }

    // Green grass strip
    canvas.drawRect(
      Rect.fromLTRB(0, groundTop, size.width, groundTop + cfg.groundGrassHeight),
      Paint()..color = const Color(0xFF4CAF50),
    );

    // Dark grass edge line
    canvas.drawLine(
      Offset(0, groundTop),
      Offset(size.width, groundTop),
      Paint()
        ..color = const Color(0xFF388E3C)
        ..strokeWidth = 2.5,
    );
  }

  // ================================================================
  // Plane
  // ================================================================

  void _drawPlane(Canvas canvas) {
    final plane = gameService.plane;
    final cfg = gameService.config;
    final w = cfg.planeWidth;
    final h = cfg.planeHeight;

    canvas.save();
    canvas.translate(plane.x, plane.y);
    canvas.rotate(plane.rotation);

    // -- Drop shadow --
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, h * 0.35), width: w * 0.75, height: h * 0.2),
      Paint()..color = const Color(0x22000000),
    );

    // -- Tail fin (red) --
    final tailPath = Path()
      ..moveTo(-w * 0.38, -h * 0.16)
      ..lineTo(-w * 0.50, -h * 0.58)
      ..lineTo(-w * 0.34, -h * 0.48)
      ..lineTo(-w * 0.26, -h * 0.16)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFFE53935));
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = const Color(0xFFC62828)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // -- Horizontal stabiliser --
    final hStab = Path()
      ..moveTo(-w * 0.40, h * 0.02)
      ..lineTo(-w * 0.50, h * 0.22)
      ..lineTo(-w * 0.33, h * 0.18)
      ..lineTo(-w * 0.30, h * 0.02)
      ..close();
    canvas.drawPath(hStab, Paint()..color = const Color(0xFFEF5350));

    // -- Top wing (blue) --
    final topWing = Path()
      ..moveTo(-w * 0.10, -h * 0.17)
      ..lineTo(-w * 0.03, -h * 0.58)
      ..lineTo(w * 0.24, -h * 0.52)
      ..lineTo(w * 0.12, -h * 0.17)
      ..close();
    canvas.drawPath(topWing, Paint()..color = const Color(0xFF1565C0));
    canvas.drawPath(
      topWing,
      Paint()
        ..color = const Color(0xFF0D47A1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Wing accent stripe
    final wingStripe = Path()
      ..moveTo(-w * 0.06, -h * 0.36)
      ..lineTo(w * 0.18, -h * 0.33)
      ..lineTo(w * 0.19, -h * 0.40)
      ..lineTo(-w * 0.05, -h * 0.43)
      ..close();
    canvas.drawPath(wingStripe, Paint()..color = const Color(0xFF42A5F5));

    // -- Bottom wing (smaller) --
    final botWing = Path()
      ..moveTo(-w * 0.04, h * 0.17)
      ..lineTo(w * 0.01, h * 0.40)
      ..lineTo(w * 0.19, h * 0.37)
      ..lineTo(w * 0.10, h * 0.17)
      ..close();
    canvas.drawPath(botWing, Paint()..color = const Color(0xFF1976D2));

    // -- Body (fuselage) --
    final bodyRect = Rect.fromCenter(center: Offset.zero, width: w, height: h * 0.38);
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(h * 0.17));
    canvas.drawRRect(
      bodyRRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
        ).createShader(bodyRect),
    );
    canvas.drawRRect(
      bodyRRect,
      Paint()
        ..color = const Color(0xFFBDBDBD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // -- Red nose stripe --
    canvas.drawLine(
      Offset(w * 0.35, -h * 0.17),
      Offset(w * 0.35, h * 0.17),
      Paint()
        ..color = const Color(0xFFE53935)
        ..strokeWidth = 3.0 * (w / 60),
    );

    // -- Engine nose --
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.46, 0), width: w * 0.12, height: h * 0.28),
      Paint()..color = const Color(0xFF455A64),
    );

    // -- Cockpit window --
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.18, -h * 0.02), width: w * 0.14, height: h * 0.18),
      Paint()..color = const Color(0xFF81D4FA),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.18, -h * 0.02), width: w * 0.14, height: h * 0.18),
      Paint()
        ..color = const Color(0xFF0288D1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // -- Propeller (spinning) --
    final propAngle = gameService.totalTime * 28.0;
    final propCenter = Offset(w * 0.52, 0);
    final propLen = h * 0.30;
    final propPaint = Paint()
      ..color = const Color(0xFF78909C)
      ..strokeWidth = 2.8 * (w / 60)
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(propCenter.dx, propCenter.dy);
    canvas.rotate(propAngle);
    canvas.drawLine(Offset(0, -propLen), Offset(0, propLen), propPaint);
    canvas.rotate(pi / 3);
    canvas.drawLine(Offset(0, -propLen), Offset(0, propLen), propPaint);
    canvas.restore();

    canvas.restore();
  }

  // ================================================================
  // Helpers
  // ================================================================

  /// Floor-modulo that always returns a non-negative result.
  static double _floorMod(double a, double b) {
    return a - b * (a / b).floorToDouble();
  }
}
