import 'package:flutter/material.dart';

import '../../model/restaurant.dart';
import 'restaurant_detail_modal.dart';

class RestaurantCarouselItem extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCarouselItem({super.key, required this.restaurant});

  void _showDetailsModel(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => RestaurantDetailModal(restaurant: restaurant),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsModel(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
