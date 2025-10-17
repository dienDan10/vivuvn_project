import 'package:flutter/material.dart';

import '../../../overview/ui/widgets/place_card.dart';
import '../schedule_data.dart';
import 'transport_section.dart';

class PlaceListSection extends StatelessWidget {
  const PlaceListSection({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        ...samplePlaces.asMap().entries.map((final entry) {
          final index = entry.key;
          final place = entry.value;

          return Column(
            children: [
              PlaceCard(title: place.title, description: place.description),
              if (index != samplePlaces.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: TransportSection(),
                ),
            ],
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }
}
