import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../overview/ui/widgets/favourite_place/place_card_image.dart';
import '../../model/itinerary_item.dart';
import 'place_time_editor.dart';

class PlaceCardHeader extends ConsumerWidget {
  const PlaceCardHeader({super.key, required this.item});

  final ItineraryItem item;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final timeText = (item.startTime == null || item.endTime == null)
        ? 'Chưa đặt giờ'
        : '${item.startTime!.format(context)} - ${item.endTime!.format(context)}';

    final location = item.location;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlaceCardImage(imageUrl: location.photos.firstOrNull, size: 80),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    timeText,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  PlaceTimeEditor(item: item),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
