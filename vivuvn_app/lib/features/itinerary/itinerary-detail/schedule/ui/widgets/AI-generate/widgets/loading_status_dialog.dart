import 'dart:async';

import 'package:flutter/material.dart';

/// A small dialog widget that shows a loading message with animated dots
/// and progresses through three stage messages every 10 seconds.
class LoadingStatusDialog extends StatefulWidget {
  const LoadingStatusDialog({super.key});

  @override
  State<LoadingStatusDialog> createState() => _LoadingStatusDialogState();
}

class _LoadingStatusDialogState extends State<LoadingStatusDialog> {
  late Timer _dotTimer;
  Timer? _stageTimer1;
  Timer? _stageTimer2;

  int _dotCount = 0;
  String _stage = 'Đang suy nghĩ';

  @override
  void initState() {
    super.initState();

    // animate dots 0..3 every 500ms
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (final t) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // 0..3
      });
    });

    // after 15s -> change to "Đang tổng hợp dữ liệu"
    _stageTimer1 = Timer(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() {
        _stage = 'Đang tổng hợp dữ liệu';
        _dotCount = 0;
      });
    });

    // after 30s (another 15s) -> change to "Đang khởi tạo lịch trình"
    _stageTimer2 = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      setState(() {
        _stage = 'Đang khởi tạo lịch trình';
        _dotCount = 0;
      });
    });
  }

  @override
  void dispose() {
    _dotTimer.cancel();
    _stageTimer1?.cancel();
    _stageTimer2?.cancel();
    super.dispose();
  }

  String get _dots => '.' * _dotCount;

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      backgroundColor: const DialogThemeData().backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_stage$_dots',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            const SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
