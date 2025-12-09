import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../itinerary/itinerary-detail/overview/data/dto/hotel_item_response.dart';
import '../../../../../itinerary/itinerary-detail/overview/ui/widgets/favourite_place/place_card_image.dart';
import '../../../../../itinerary/itinerary-detail/overview/ui/widgets/shared/location_action_buttons.dart';

class HotelItemCard extends StatelessWidget {
  final HotelItemResponse hotel;

  const HotelItemCard({required this.hotel, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

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
                    hotel.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (hotel.address.isNotEmpty)
                    Text(
                      hotel.address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Text(
                    'Nhận phòng: ${hotel.checkInDate != null ? DateFormat('dd/MM/yyyy', 'vi').format(hotel.checkInDate!) : '--/--'} - Trả phòng: ${hotel.checkOutDate != null ? DateFormat('dd/MM/yyyy', 'vi').format(hotel.checkOutDate!) : '--/--'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hotel.cost != null && hotel.cost! > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${NumberFormat('#,###').format(hotel.cost)} VNĐ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (hotel.note != null && hotel.note!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hotel.note!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  LocationActionButtons(
                    placeUri: hotel.placeUri,
                    directionsUri: hotel.directionsUri,
                    fallbackQuery: '${hotel.name}, ${hotel.address}',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PlaceCardImage(
              imageUrl: hotel.imageUrl,
              size: 120,
            ),
          ],
        ),
      ),
    );
  }
}

