import 'package:flutter/material.dart';

import '../../../models/location.dart';
import 'location_card_content.dart';

class LocationSuggestionCard extends StatelessWidget {
  const LocationSuggestionCard({
    super.key,
    required this.location,
    this.isAlreadyAdded = false,
  });

  final Location location;
  final bool isAlreadyAdded;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 4),
      elevation: 0,
      color: isAlreadyAdded
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: LocationCardContent(
          location: location,
          isAlreadyAdded: isAlreadyAdded,
        ),
      ),
    );
  }
}
