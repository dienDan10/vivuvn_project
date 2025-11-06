import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/join_itinerary_controller.dart';
import '../painters/corner_frame_painter.dart';
import '../painters/scan_line_painter.dart';

class QrOverlayFrame extends ConsumerWidget {
  final Animation<double> scanAnimation;

  const QrOverlayFrame({super.key, required this.scanAnimation});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    const overlaySize = 240.0;
    final pickedImagePath = ref.watch(
      joinItineraryControllerProvider.select((final s) => s.pickedImagePath),
    );
    return Center(
      child: SizedBox(
        width: overlaySize,
        height: overlaySize,
        child: Stack(
          children: [
            CustomPaint(
              painter: CornerFramePainter(
                color: Colors.grey,
                strokeWidth: 4,
                cornerLength: 28,
                radius: 16,
              ),
              child: const SizedBox.expand(),
            ),
            AnimatedBuilder(
              animation: scanAnimation,
              builder: (final _, final __) {
                return CustomPaint(
                  painter: ScanLinePainter(
                    progress: scanAnimation.value,
                    color: Colors.grey,
                    radius: 16,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
            if (pickedImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  width: overlaySize,
                  height: overlaySize,
                  child: Image.file(
                    File(pickedImagePath),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


