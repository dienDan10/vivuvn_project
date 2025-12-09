import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../itinerary/itinerary-detail/overview/data/dto/restaurant_item_response.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/favourite_place/place_card_image.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/shared/location_action_buttons.dart';

class RestaurantSection extends StatefulWidget {
  final List<RestaurantItemResponse> restaurants;

  const RestaurantSection({
    required this.restaurants,
    super.key,
  });

  @override
  State<RestaurantSection> createState() => _RestaurantSectionState();
}

class _RestaurantSectionState extends State<RestaurantSection> {
  bool _expanded = true;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Nhà hàng',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() => _expanded = !_expanded);
                },
              ),
            ],
          ),
        ),
        if (_expanded)
          ...widget.restaurants.map((final restaurant) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (restaurant.address.isNotEmpty)
                            Text(
                              restaurant.address,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (restaurant.mealDate != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Thời gian: ${DateFormat('dd/MM/yyyy HH:mm', 'vi').format(restaurant.mealDate!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (restaurant.cost != null && restaurant.cost! > 0) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.attach_money, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${NumberFormat('#,###').format(restaurant.cost)} VNĐ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (restaurant.note != null && restaurant.note!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                restaurant.note!,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          LocationActionButtons(
                            placeUri: restaurant.placeUri,
                            directionsUri: restaurant.directionsUri,
                            fallbackQuery: '${restaurant.name}, ${restaurant.address}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    PlaceCardImage(
                      imageUrl: restaurant.imageUrl,
                      size: 120,
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

