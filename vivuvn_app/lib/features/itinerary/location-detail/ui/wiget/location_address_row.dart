import 'package:flutter/material.dart';

class LocationAddressRow extends StatelessWidget {
  final String address;

  const LocationAddressRow({super.key, required this.address});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              address,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15.5,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
