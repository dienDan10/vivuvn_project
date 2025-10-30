import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/restaurants_controller.dart';
import 'add_restaurant_button.dart';
import 'animated_restaurant_card.dart';
import 'restaurant_list_header.dart';

class RestaurantListItem extends ConsumerWidget {
  const RestaurantListItem({
    required this.index,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int index;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(
      restaurantsControllerProvider.select((s) => s.restaurants),
    );

    // Header
    if (index == 0) {
      return RestaurantListHeader(
        restaurantsCount: restaurants.length,
        isExpanded: isExpanded,
        iconRotationAnimation: iconRotationAnimation,
        onToggle: onToggle,
      );
    }

    // Collapsed spacing
    if (!isExpanded) {
      if (index == 1) {
        return const SizedBox(height: 8);
      }
      return const SizedBox.shrink();
    }

    // Restaurant cards
    if (index <= restaurants.length) {
      final restaurant = restaurants[index - 1];
      return AnimatedRestaurantCard(
        restaurant: restaurant,
        index: index,
        isExpanded: isExpanded,
      );
    }

    // Spacing after cards
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
