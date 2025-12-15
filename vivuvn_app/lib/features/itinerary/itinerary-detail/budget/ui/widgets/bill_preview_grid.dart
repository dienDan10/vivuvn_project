import 'dart:io';

import 'package:flutter/material.dart';

/// Grid preview ảnh bill/hóa đơn: hiển thị ảnh thật từ path hoặc URL.
class BillPreviewGrid extends StatelessWidget {
  final List<String> previews;

  const BillPreviewGrid({super.key, required this.previews});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    if (previews.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(previews.length, (final index) {
        final path = previews[index];
        final isNetwork = path.startsWith('http');

        final imageWidget = isNetwork
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, final __, final ___) => const Icon(Icons.broken_image),
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, final __, final ___) => const Icon(Icons.broken_image),
              );

        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageWidget,
        );
      }),
    );
  }
}


