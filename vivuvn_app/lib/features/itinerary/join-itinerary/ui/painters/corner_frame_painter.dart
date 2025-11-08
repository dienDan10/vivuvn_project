import 'package:flutter/material.dart';

class CornerFramePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double radius;

  CornerFramePainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.radius,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final r = radius;
    final cl = cornerLength;

    // Top-left
    canvas.drawLine(Offset(r, 0), Offset(r + cl, 0), paint);
    canvas.drawLine(Offset(0, r), Offset(0, r + cl), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - r - cl, 0), Offset(size.width - r, 0), paint);
    canvas.drawLine(Offset(size.width, r), Offset(size.width, r + cl), paint);

    // Bottom-left
    canvas.drawLine(Offset(r, size.height), Offset(r + cl, size.height), paint);
    canvas.drawLine(Offset(0, size.height - r - cl), Offset(0, size.height - r), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - r - cl, size.height), Offset(size.width - r, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - r - cl), Offset(size.width, size.height - r), paint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}


