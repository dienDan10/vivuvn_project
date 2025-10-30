import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'place_card_image.dart';

class RestaurantCardHeader extends StatelessWidget {
  const RestaurantCardHeader({
    required this.restaurantId,
    required this.name,
    required this.address,
    required this.mealDate,
    required this.imageUrl,
    required this.onTap,
    super.key,
  });

  final String restaurantId;
  final String name;
  final String address;
  final DateTime? mealDate;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mealDate != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Thời gian: ${dateFormatter.format(mealDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            PlaceCardImage(
              imageUrl: imageUrl,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
