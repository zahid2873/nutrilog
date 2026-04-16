import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';

// ─── CALORIE RING PAINTER ─────────────────────────────────────────────────────
class CalorieRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  CalorieRingPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;

    final bgPaint = Paint()
      ..color = HelperFunction.colorWithOpacity(Colors.white, 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * min(progress, 1.0),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CalorieRingPainter old) =>
      old.progress != progress;
}
