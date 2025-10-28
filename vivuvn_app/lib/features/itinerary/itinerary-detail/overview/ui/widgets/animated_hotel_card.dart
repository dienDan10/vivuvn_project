import 'package:flutter/material.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'slidable_hotel_card.dart';

class AnimatedHotelCard extends StatelessWidget {
  const AnimatedHotelCard({
    required this.hotel,
    required this.index,
    required this.isExpanded,
    super.key,
  });

  final HotelItem hotel;
  final int index;
  final bool isExpanded;

  @override
  Widget build(final BuildContext context) {
    return AnimatedOpacity(
      opacity: isExpanded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedSlide(
        offset: isExpanded ? Offset.zero : const Offset(0, -0.2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SlidableHotelCard(
          key: ValueKey(hotel.id),
          hotel: hotel,
          index: index,
        ),
      ),
    );
  }
}
