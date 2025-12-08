import 'package:flutter/material.dart';

import '../../data/dto/itinerary_dto.dart';
import 'itinerary_carousel.dart';

class ItinerarySection extends StatelessWidget {
  final List<ItineraryDto> itineraries;

  const ItinerarySection({required this.itineraries, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Text(
            'Lịch trình công khai gần đây',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ItineraryCarousel(itineraries: itineraries),
      ],
    );
  }
}
