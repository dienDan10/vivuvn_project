import 'package:flutter/material.dart';

import '../../data/dto/destination_dto.dart';
import 'destination_card.dart';

class DestinationCarousel extends StatelessWidget {
  final List<DestinationDto> destinations;

  const DestinationCarousel({required this.destinations, super.key});

  @override
  Widget build(final BuildContext context) {
    if (destinations.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Không có dữ liệu địa điểm')),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: destinations.length,
        itemBuilder: (final context, final index) {
          return DestinationCard(destination: destinations[index]);
        },
      ),
    );
  }
}
