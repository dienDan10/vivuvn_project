import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'add_place_button.dart';
import 'slidable_place_item.dart';

class PlaceListSection extends ConsumerWidget {
  const PlaceListSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final days = ref.watch(
      itineraryScheduleControllerProvider.select((final state) => state.days),
    );
    final selectedIndex = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.selectedIndex,
      ),
    );

    final selectedDay = (days.isNotEmpty && selectedIndex < days.length)
        ? days[selectedIndex]
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
            key: ValueKey(entry.value.itineraryItemId),
            item: entry.value,
          ),
        ],
        const SizedBox(height: 24),
        const AddPlaceButton(),
      ],
    );
  }
}
