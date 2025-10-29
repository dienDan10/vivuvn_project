import 'package:flutter/material.dart';

import '../../data/dto/restaurant_item_response.dart';
import 'slidable_restaurant_card.dart';

class AnimatedRestaurantCard extends StatelessWidget {
  const AnimatedRestaurantCard({
    required this.restaurant,
    required this.index,
    required this.isExpanded,
    super.key,
  });

  final RestaurantItemResponse restaurant;
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
        child: SlidableRestaurantCard(
          key: ValueKey(restaurant.id),
          restaurant: restaurant,
          index: index,
        ),
      ),
    );
  }
}
