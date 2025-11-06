import 'package:flutter/material.dart';

class ScanWindowPainter extends CustomPainter {
  final double windowSize;

  ScanWindowPainter({required this.windowSize});

  @override
  void paint(final Canvas canvas, final Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);

    final rect = Offset.zero & size;
    final windowRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: windowSize,
      height: windowSize,
    );

    final path = Path()
      ..addRect(rect)
      ..addRRect(RRect.fromRectAndRadius(windowRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}


