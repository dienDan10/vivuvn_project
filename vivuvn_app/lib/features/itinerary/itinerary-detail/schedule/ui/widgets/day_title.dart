import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';

class DayTitle extends ConsumerWidget {
  const DayTitle({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);

    final days = state.days;
    final selectedIndex = state.selectedIndex;
    final selectedDay = (days.isNotEmpty && selectedIndex < days.length)
        ? days[selectedIndex]
        : null;

    final dayText = selectedDay == null
        ? 'Không có ngày'
        : 'Ngày ${selectedDay.dayNumber} - '
              '${selectedDay.date?.day}/${selectedDay.date?.month}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        dayText,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
