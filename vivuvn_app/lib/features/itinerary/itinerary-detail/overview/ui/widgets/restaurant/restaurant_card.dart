import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/restaurant_card_expand_controller.dart';
import '../../../data/dto/restaurant_item_response.dart';
import 'restaurant_card_expanded.dart';
import 'restaurant_card_header.dart';

class RestaurantCard extends ConsumerWidget {
  const RestaurantCard({required this.restaurant, this.index, super.key});

  final RestaurantItemResponse restaurant;
  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final expandState = ref.watch(restaurantCardExpandControllerProvider);
    final isExpanded = expandState.isExpanded(restaurant.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RestaurantCardHeader(
            restaurantId: restaurant.id,
            name: restaurant.name,
            address: restaurant.address,
            mealDate: restaurant.mealDate,
            imageUrl: restaurant.imageUrl,
            onTap: () {
              ref
                  .read(restaurantCardExpandControllerProvider.notifier)
                  .toggle(restaurant.id);
            },
          ),
          if (isExpanded)
            RestaurantCardExpanded(
              restaurantId: restaurant.id,
              restaurantName: restaurant.name,
              mealDate: restaurant.mealDate,
              cost: restaurant.cost,
              note: restaurant.note,
            ),
        ],
      ),
    );
  }
}
