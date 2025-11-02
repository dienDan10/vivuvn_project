import 'package:flutter/material.dart';

class PlaceCardDescription extends StatelessWidget {
  const PlaceCardDescription({required this.description, super.key});

  final String description;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      description,
      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
