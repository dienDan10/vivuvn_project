import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/routes.dart';
import '../../model/location.dart';

class PlaceActionButtonRestaurant extends StatelessWidget {
  final Location location;
  const PlaceActionButtonRestaurant({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        context.push(nearbyRestaurantRoute, extra: location);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Nhà hàng',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
