import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/expense_bill_controller.dart';
import '../../../state/expense_bill_state.dart';
import '../bill_preview_grid.dart';
import 'bill_attachment_sizes.dart';
import 'bill_preview_dialog.dart';

/// Ô preview hình bill + nút xoá.
class BillAttachmentPreviewBox extends ConsumerWidget {
  const BillAttachmentPreviewBox({
    super.key,
    required this.sizes,
  });

  final BillAttachmentSizes sizes;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ExpenseBillState billState = ref.watch(expenseBillControllerProvider);
    final controller = ref.read(expenseBillControllerProvider.notifier);

    final previews = billState.localImagePaths;
    final preview = previews.isNotEmpty ? previews.first : null;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: preview == null
                ? null
                : () => BillPreviewDialog.show(context, preview),
            child: BillPreviewGrid(previews: preview != null ? [preview] : []),
          ),
        ),
        if (preview != null)
          Positioned(
            top: 0,
            right: (4 * (sizes.gap / 12)).clamp(2.0, 8.0),
            child: IconButton(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              style: IconButton.styleFrom(
                minimumSize: Size(sizes.closeButtonSize, sizes.closeButtonSize),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.error.withValues(
                      alpha: 0.18,
                    ),
              ),
              onPressed:
                  billState.isSavingToGallery ? null : () => controller.removeBillAt(0),
              icon: Icon(
                Icons.close,
                size: sizes.closeIconSize,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Xóa ảnh hóa đơn',
            ),
          ),
      ],
    );
  }
}


