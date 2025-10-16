import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final int? index; // ← Thêm số thứ tự (optional)

  const PlaceCard({
    super.key,
    required this.title,
    required this.description,
    this.index,
  });

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // padding: const EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   color: colorScheme.surface,
      //   borderRadius: BorderRadius.circular(12),
      // boxShadow: [
      //   BoxShadow(
      //     color: colorScheme.shadow.withValues(alpha: 0.05),
      //     blurRadius: 4,
      //     offset: const Offset(0, 1),
      //   ),
      // ],
      // ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (index != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                      ),
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
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: colorScheme.primaryContainer, // thay cho blue.shade100
              child: Icon(
                Icons.image,
                color: colorScheme.onPrimaryContainer,
                size: 30,
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.more_vert, color: colorScheme.outline),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
