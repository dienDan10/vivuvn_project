import 'package:flutter/material.dart';

class ScanLinePainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final double radius;

  ScanLinePainter({
    required this.progress,
    required this.color,
    required this.radius,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    final y = progress * size.height;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.9),
          color.withValues(alpha: 0.0),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, y - 1, size.width, 2))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0 + radius, y)
      ..lineTo(size.width - radius, y);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(final ScanLinePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}


