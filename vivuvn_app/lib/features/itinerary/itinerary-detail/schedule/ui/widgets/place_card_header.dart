import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../overview/ui/widgets/place_card_image.dart';
import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';

class PlaceCardHeader extends ConsumerWidget {
  const PlaceCardHeader({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);
    final controller = ref.read(itineraryScheduleControllerProvider.notifier);

    // Lấy item hiện tại theo selectedDayId + location
    final currentItem = state.selectedDayId != null
        ? state.days
              .firstWhereOrNull((final d) => d.id == state.selectedDayId)
              ?.items
              .firstWhereOrNull(
                (final i) =>
                    i.itineraryItemId == state.selectedItem?.itineraryItemId,
              )
        : null;

    String timeText() {
      final item = state.selectedItem ?? currentItem;
      if (item == null || item.startTime == null || item.endTime == null) {
        return 'Chưa đặt giờ';
      }
      final format = NumberFormat('00');
      return '${format.format(item.startTime!.hour)}:${format.format(item.startTime!.minute)} - '
          '${format.format(item.endTime!.hour)}:${format.format(item.endTime!.minute)}';
    }

    Future<void> pickTime() async {
      if (currentItem == null || state.selectedDayId == null) return;

      final start = currentItem.startTime != null
          ? TimeOfDay(
              hour: currentItem.startTime!.hour,
              minute: currentItem.startTime!.minute,
            )
          : const TimeOfDay(hour: 7, minute: 0);

      final end = currentItem.endTime != null
          ? TimeOfDay(
              hour: currentItem.endTime!.hour,
              minute: currentItem.endTime!.minute,
            )
          : TimeOfDay(hour: (start.hour + 1) % 24, minute: start.minute);

      final newStart = await showTimePicker(
        context: context,
        initialTime: start,
      );
      if (newStart == null) return;

      final newEnd = await showTimePicker(context: context, initialTime: end);
      if (newEnd == null) return;

      await controller.updateItem(
        dayId: state.selectedDayId!,
        itemId: currentItem.itineraryItemId,
        startTime: newStart,
        endTime: newEnd,
      );
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
                  InkWell(
                    onTap: currentItem != null ? pickTime : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: currentItem != null
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mode_edit_outline_rounded,
                        size: 16,
                        color: currentItem != null ? Colors.blue : Colors.grey,
                      ),
                    ),
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
