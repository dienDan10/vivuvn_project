import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'add_place_button.dart';
import 'slidable_place_item.dart';
import 'transport_section.dart';

class PlaceListSection extends ConsumerWidget {
  const PlaceListSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);
    final selectedDay =
        (state.days.isNotEmpty && state.selectedIndex < state.days.length)
        ? state.days[state.selectedIndex]
        : null;

    if (selectedDay == null) return const SizedBox();

    final items = selectedDay.items;

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: AddPlaceButton(),
      );
    }

    return Column(
      children: [
        for (final entry in items.asMap().entries) ...[
          SlidablePlaceItem(
            item: entry.value,
            dayId: selectedDay.id,
            index: entry.key,
          ),
          if (entry.key != items.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TransportSection(index: entry.key),
            ),
        ],
        const SizedBox(height: 8),
        const AddPlaceButton(),
      ],
    );
  }
}
