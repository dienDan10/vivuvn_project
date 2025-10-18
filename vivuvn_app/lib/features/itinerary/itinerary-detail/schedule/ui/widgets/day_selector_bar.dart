import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/itinerary_schedule_controller.dart';
import 'day_selector_button.dart';

class DaySelectorBar extends ConsumerWidget {
  const DaySelectorBar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);

    final days = state.days;
    final selectedIndex = state.selectedIndex;

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Lỗi: ${state.error}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    if (days.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Chưa có ngày nào trong lịch trình.'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(days.length, (final index) {
                  final date = days[index].date;
                  final label = date != null
                      ? '${date.day}/${date.month}' // ví dụ 26/10
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
