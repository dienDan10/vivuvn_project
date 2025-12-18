import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/expense_bill_controller.dart';
import '../../../state/expense_bill_state.dart';
import 'bill_attachment_sizes.dart';

/// Khu vực bấm để mở gallery chọn ảnh bill.
class BillAttachmentUploadTile extends ConsumerWidget {
  const BillAttachmentUploadTile({
    super.key,
    required this.sizes,
    this.enabled = true,
  });

  final BillAttachmentSizes sizes;
  final bool enabled;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ExpenseBillState billState = ref.watch(expenseBillControllerProvider);
    final controller = ref.read(expenseBillControllerProvider.notifier);
    final theme = Theme.of(context);
    final hasPreview = billState.localImagePaths.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(sizes.cardRadius),
        onTap: (!enabled || billState.isPicking)
            ? null
            : () => controller.pickBillsFromGallery(context),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sizes.labelGap),
          child: Row(
            children: [
              Container(
                width: sizes.iconBox,
                height: sizes.iconBox,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(sizes.iconRadius),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: sizes.gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tải lên ảnh hóa đơn',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: sizes.labelGap),
                    Text(
                      hasPreview ? 'Đã chọn 1 ảnh' : '(jpg, png)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.upload_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
