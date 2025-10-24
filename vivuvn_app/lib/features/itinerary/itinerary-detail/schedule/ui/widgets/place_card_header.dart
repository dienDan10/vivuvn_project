import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../overview/ui/widgets/place_card_image.dart';
import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';
import 'place_time_editor.dart';

class PlaceCardHeader extends ConsumerWidget {
  const PlaceCardHeader({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);

    final currentDay = state.days.firstWhereOrNull(
      (final d) => d.id == state.selectedDayId,
    );

    final currentItem = currentDay?.items.firstWhereOrNull(
      (final i) => i.location.id == location.id,
    );

    String timeText() {
      if (currentItem == null ||
          currentItem.startTime == null ||
          currentItem.endTime == null) {
        return 'Chưa đặt giờ';
      }
      final format = NumberFormat('00');
      return '${format.format(currentItem.startTime!.hour)}:${format.format(currentItem.startTime!.minute)} - '
          '${format.format(currentItem.endTime!.hour)}:${format.format(currentItem.endTime!.minute)}';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlaceCardImage(
          imageUrl: location.photos.isNotEmpty ? location.photos.first : null,
          size: 80,
        ),
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
                    timeText(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  PlaceTimeEditor(
                    currentDay: currentDay,
                    currentItem: currentItem,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
