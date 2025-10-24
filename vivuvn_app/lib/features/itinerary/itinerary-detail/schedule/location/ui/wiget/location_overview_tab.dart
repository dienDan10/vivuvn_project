import 'package:flutter/material.dart';

import '../../../ui/widgets/place_action_button_direction.dart';
import '../../../ui/widgets/place_action_button_location.dart';
import '../../../ui/widgets/place_action_button_website.dart';

class LocationOverviewTab extends StatelessWidget {
  final dynamic location;
  const LocationOverviewTab({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${location.rating} (${location.ratingCount} đánh giá)',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.redAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location.address,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              PlaceActionButtonLocation(),
              PlaceActionButtonDirection(),
              PlaceActionButtonWebsite(),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
