import 'package:flutter/material.dart';

import '../../data/dto/itinerary_dto.dart';
import 'empty_state_widget.dart';
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
            'Lịch trình gần đây',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        itineraries.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.calendar_today_outlined,
                message: 'Không có lịch trình gần đây',
              )
            : ItineraryCarousel(itineraries: itineraries),
      ],
    );
  }
}
