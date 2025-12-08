import 'package:flutter/material.dart';

import '../../data/dto/destination_dto.dart';
import 'destination_carousel.dart';

class DestinationSection extends StatelessWidget {
  final List<DestinationDto> destinations;

  const DestinationSection({required this.destinations, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Text(
            'Địa điểm phổ biến',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DestinationCarousel(destinations: destinations),
      ],
    );
  }
}
