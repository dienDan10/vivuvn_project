import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'day_selector_button.dart';

class DaySelectorBar extends ConsumerWidget {
  const DaySelectorBar({super.key});

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
    final isLoading = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.isLoading,
      ),
    );
    final error = ref.watch(
      itineraryScheduleControllerProvider.select((final state) => state.error),
    );

    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (error != null) {
      return const SizedBox.shrink();
    }

    Future<void> openDateRangePicker() async {
      final initialStart = days.first.date ?? DateTime.now();
      final initialEnd =
          days.last.date ?? DateTime.now().add(const Duration(days: 2));

      final config = CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDayOfWeek: 1,
      );

      final result = await showCalendarDatePicker2Dialog(
        context: context,
        value: [initialStart, initialEnd],
        config: config,
        dialogSize: const Size(340, 400),
        borderRadius: BorderRadius.circular(12),
      );

      if (result != null && result.isNotEmpty) {
        DateTime? start = result[0];
        DateTime? end = result.length > 1 ? result[1] : null;

        if (start != null && end != null && end.isBefore(start)) {
          final tmp = start;
          start = end;
          end = tmp;
        }

        if (start != null && end != null) {
          // Gọi controller để update startDate / endDate
          ref
              .read(itineraryScheduleControllerProvider.notifier)
              .updateDates(start, end);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          GestureDetector(
            onTap: openDateRangePicker,
            child: Icon(
              Icons.calendar_today_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(days.length, (final index) {
                  final date = days[index].date;
                  final label = date != null
                      ? '${date.day}/${date.month}'
                      : 'Ngày ${days[index].dayNumber}';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DaySelectorButton(
                      label: label,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        ref
                            .read(itineraryScheduleControllerProvider.notifier)
                            .selectDay(index);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
