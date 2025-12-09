import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/home_controller.dart';
import '../../data/dto/itinerary_dto.dart';
import 'itinerary_card.dart';

class ItineraryCarousel extends ConsumerWidget {
  final List<ItineraryDto> itineraries;

  const ItineraryCarousel({required this.itineraries, super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (itineraries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Không có dữ liệu lịch trình')),
      );
    }

    final pageController = ref.watch(itineraryPageControllerProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.26,
      child: PageView.builder(
        controller: pageController,
        itemCount: itineraries.length,
        itemBuilder: (final context, final index) {
          return ItineraryCard(itinerary: itineraries[index]);
        },
      ),
    );
  }
}
