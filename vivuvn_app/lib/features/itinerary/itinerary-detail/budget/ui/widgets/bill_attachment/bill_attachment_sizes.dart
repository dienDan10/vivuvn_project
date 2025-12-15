import 'package:flutter/material.dart';

/// Tập hợp kích thước responsive cho ô upload bill.
class BillAttachmentSizes {
  final double padding;
  final double cardRadius;
  final double iconBox;
  final double iconRadius;
  final double gap;
  final double previewSize;
  final double closeIconSize;
  final double closeButtonSize;
  final double labelGap;

  const BillAttachmentSizes({
    required this.padding,
    required this.cardRadius,
    required this.iconBox,
    required this.iconRadius,
    required this.gap,
    required this.previewSize,
    required this.closeIconSize,
    required this.closeButtonSize,
    required this.labelGap,
  });

  factory BillAttachmentSizes.fromContext(final BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = (screenWidth / 400).clamp(0.8, 1.15);

    return BillAttachmentSizes(
      padding: (12 * scale).clamp(8.0, 14.0).toDouble(),
      cardRadius: (12 * scale).clamp(10.0, 14.0).toDouble(),
      iconBox: (44 * scale).clamp(36.0, 52.0).toDouble(),
      iconRadius: (10 * scale).clamp(8.0, 12.0).toDouble(),
      gap: (12 * scale).clamp(8.0, 14.0).toDouble(),
      previewSize: (120 * scale).clamp(110.0, 150.0).toDouble(),
      closeIconSize: (16 * scale).clamp(14.0, 18.0).toDouble(),
      closeButtonSize: (28 * scale).clamp(24.0, 32.0).toDouble(),
      labelGap: (4 * scale).clamp(2.0, 6.0).toDouble(),
    );
  }
}


