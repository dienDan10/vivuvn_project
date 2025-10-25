import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'place_card_image.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({required this.restaurant, this.index, super.key});

  final RestaurantItem restaurant;
  final int? index;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.address,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                if (restaurant.mealDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Ngày ăn: ${DateFormat('dd/MM/yyyy').format(restaurant.mealDate!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PlaceCardImage(imageUrl: restaurant.imageUrl, size: 80),
        ],
      ),
    );
  }
}
