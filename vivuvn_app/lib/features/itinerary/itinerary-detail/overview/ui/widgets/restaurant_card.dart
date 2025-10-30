import 'package:flutter/material.dart';

import '../../data/dto/restaurant_item_response.dart';
import 'restaurant_card_expanded.dart';
import 'restaurant_card_header.dart';

class RestaurantCard extends StatefulWidget {
  const RestaurantCard({required this.restaurant, this.index, super.key});

  final RestaurantItemResponse restaurant;
  final int? index;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

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
            onTap: _toggle,
          ),
          if (_expanded)
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
