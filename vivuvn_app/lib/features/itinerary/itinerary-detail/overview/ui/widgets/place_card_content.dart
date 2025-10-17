import 'package:flutter/material.dart';

class PlaceCardContent extends StatelessWidget {
  const PlaceCardContent({
    required this.title,
    required this.description,
    this.index,
    super.key,
  });

  final String title;
  final String description;
  final int? index;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 6),
        _buildDescription(context),
      ],
    );
  }

  /// Header với badge số thứ tự và title
  Widget _buildHeader(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        if (index != null) ...[
          _buildIndexBadge(colorScheme, textTheme),
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

  /// Badge hiển thị số thứ tự
  Widget _buildIndexBadge(
    final ColorScheme colorScheme,
    final TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '#$index',
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Description text
  Widget _buildDescription(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      description,
      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }
}
