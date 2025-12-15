import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bill_attachment/bill_attachment_card.dart';
import 'bill_attachment/bill_attachment_preview_box.dart';
import 'bill_attachment/bill_attachment_sizes.dart';
import 'bill_attachment/bill_attachment_upload_tile.dart';

/// Hiển thị khung upload ảnh hóa đơn + grid preview.
class FieldBillAttachment extends ConsumerWidget {
  const FieldBillAttachment({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final sizes = BillAttachmentSizes.fromContext(context);

    return BillAttachmentCard(
      sizes: sizes,
      leading: BillAttachmentUploadTile(sizes: sizes),
      preview: BillAttachmentPreviewBox(sizes: sizes),
    );
  }
}
