import 'package:flutter/material.dart';

import '../../modal/location.dart';
import 'already_added_badge.dart';
import 'place_icon.dart';
import 'place_info.dart';

class LocationCardContent extends StatelessWidget {
  const LocationCardContent({
    super.key,
    required this.location,
    this.isAlreadyAdded = false,
  });

  final Location location;
  final bool isAlreadyAdded;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          PlaceIcon(opacity: isAlreadyAdded ? 0.5 : 1.0),
          const SizedBox(width: 12),
          Expanded(
            child: PlaceInfo(
              name: location.name,
              address: location.provinceName ?? location.address,
              opacity: isAlreadyAdded ? 0.5 : 1.0,
            ),
          ),
          if (isAlreadyAdded) const AlreadyAddedBadge(),
        ],
      ),
    );
  }
}
