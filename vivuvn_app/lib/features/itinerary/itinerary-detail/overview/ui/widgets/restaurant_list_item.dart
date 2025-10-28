import 'package:flutter/material.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'add_restaurant_button.dart';
import 'animated_restaurant_card.dart';
import 'restaurant_list_header.dart';

class RestaurantListItem extends StatelessWidget {
  const RestaurantListItem({
    required this.index,
    required this.restaurants,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int index;
  final List<RestaurantItem> restaurants;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    // Header với toggle button
    if (index == 0) {
      return RestaurantListHeader(
        restaurantsCount: restaurants.length,
        isExpanded: isExpanded,
        iconRotationAnimation: iconRotationAnimation,
        onToggle: onToggle,
      );
    }

    // Nếu đang thu gọn, chỉ hiển thị bottom spacing
    if (!isExpanded) {
      if (index == 1) {
        return const SizedBox(height: 8);
      }
      return const SizedBox.shrink();
    }

    // Restaurant cards với animation
    if (index <= restaurants.length) {
      final restaurant = restaurants[index - 1];
      return AnimatedRestaurantCard(
        restaurant: restaurant,
        index: index,
        isExpanded: isExpanded,
      );
    }

    // Spacing sau restaurant cards
    if (index == restaurants.length + 1) {
      return const SizedBox(height: 8);
    }

    // Add button
    if (index == restaurants.length + 2) {
      return const AddRestaurantButton();
    }

    // Bottom spacing
    return const SizedBox(height: 8);
  }
}
