import 'package:flutter/material.dart';

class LocationDescription extends StatelessWidget {
  final String description;

  const LocationDescription({super.key, required this.description});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới thiệu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description.isEmpty
                ? 'Không có mô tả chi tiết cho địa điểm này.'
                : description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              height: 1.6,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
