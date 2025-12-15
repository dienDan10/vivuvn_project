import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/expense_bill_controller.dart';
import '../../../state/expense_bill_state.dart';

class BillPreviewDialog extends ConsumerWidget {
  const BillPreviewDialog({super.key, required this.path});

  final String path;

  static Future<void> show(final BuildContext context, final String path) async {
    await showDialog<void>(
      context: context,
      builder: (final ctx) => BillPreviewDialog(path: path),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ExpenseBillState billState = ref.watch(expenseBillControllerProvider);
    final controller = ref.read(expenseBillControllerProvider.notifier);
    final isNetwork = path.startsWith('http');
    final image = isNetwork
        ? Image.network(path, fit: BoxFit.contain)
        : Image.file(File(path), fit: BoxFit.contain);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(child: image),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: FilledButton.icon(
                icon: billState.isSavingToGallery
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  billState.isSavingToGallery ? 'Đang lưu...' : 'Tải về',
                ),
                onPressed: billState.isSavingToGallery
                    ? null
                    : () => controller.savePreviewToGallery(context, path),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


