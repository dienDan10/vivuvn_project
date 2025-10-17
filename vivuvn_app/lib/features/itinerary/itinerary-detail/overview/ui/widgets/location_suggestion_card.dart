import 'package:flutter/material.dart';

import '../../data/dto/search_location_response.dart';
import 'place_icon.dart';
import 'place_info.dart';

class LocationSuggestionCard extends StatelessWidget {
  const LocationSuggestionCard({super.key, required this.location});

  final SearchLocationResponse location;

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 4),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const PlaceIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: PlaceInfo(
                  name: location.name,
                  address: location.provinceName ?? location.address,
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
