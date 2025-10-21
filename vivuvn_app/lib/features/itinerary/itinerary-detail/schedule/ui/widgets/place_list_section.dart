import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';
import '../../controller/itinerary_schedule_controller.dart';
import 'add_place_button.dart';
import 'slidable_place_item.dart';
import 'transport_section.dart';

class PlaceListSection extends ConsumerWidget {
  final int dayId;

  const PlaceListSection({super.key, required this.dayId});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final scheduleState = ref.watch(itineraryScheduleControllerProvider);
    final detailState = ref.watch(itineraryDetailControllerProvider);
    final itineraryId = detailState.itineraryId;

    final days = scheduleState.days;
    if (days.isEmpty) {
      return const Center(child: Text('Không có ngày nào trong lịch trình.'));
    }

    final selectedDay = days[scheduleState.selectedIndex];
    final items = selectedDay.items;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: AddPlaceButton(dayId: dayId),
      );
    }

    return Column(
      children: [
        ...items.asMap().entries.map((final entry) {
          final index = entry.key;
          final item = entry.value;
          final location = item.location;
          if (location == null) return const SizedBox.shrink();

          return Column(
            children: [
              SlidablePlaceItem(
                itineraryId: itineraryId!,
                dayId: dayId,
                itemId: item.itineraryItemId,
                locationName: location.name,
                locationId: location.id,
                index: index,
                location: location,
              ),
              if (index != items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TransportSection(index: index),
                ),
            ],
          );
        }),
        const SizedBox(height: 8),
        AddPlaceButton(dayId: dayId),
      ],
    );
  }
}
