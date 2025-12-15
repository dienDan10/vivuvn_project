import 'package:flutter/material.dart';

import 'bill_attachment_sizes.dart';

/// Khối bao ngoài cho phần upload bill.
class BillAttachmentCard extends StatelessWidget {
  const BillAttachmentCard({
    super.key,
    required this.sizes,
    required this.leading,
    required this.preview,
  });

  final BillAttachmentSizes sizes;
  final Widget leading;
  final Widget preview;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(sizes.padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizes.cardRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          style: BorderStyle.solid,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: leading),
          SizedBox(width: sizes.gap),
          SizedBox(
            width: sizes.previewSize,
            height: sizes.previewSize,
            child: preview,
          ),
        ],
      ),
    );
  }
}


