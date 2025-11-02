import 'package:flutter/material.dart';

import 'place_card_index_badge.dart';

class PlaceCardHeader extends StatelessWidget {
  const PlaceCardHeader({required this.title, this.index, super.key});

  final String title;
  final int? index;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        if (index != null) ...[
          PlaceCardIndexBadge(index: index!),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
