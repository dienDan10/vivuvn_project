import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bill_attachment/bill_attachment_card.dart';
import 'bill_attachment/bill_attachment_preview_box.dart';
import 'bill_attachment/bill_attachment_sizes.dart';
import 'bill_attachment/bill_attachment_upload_tile.dart';

/// Hiển thị khung upload ảnh hóa đơn + grid preview.
class FieldBillAttachment extends ConsumerWidget {
  final bool enabled;

  const FieldBillAttachment({super.key, this.enabled = true});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final sizes = BillAttachmentSizes.fromContext(context);

    return BillAttachmentCard(
      sizes: sizes,
      leading: BillAttachmentUploadTile(sizes: sizes, enabled: enabled),
      preview: BillAttachmentPreviewBox(sizes: sizes),
    );
  }
}
