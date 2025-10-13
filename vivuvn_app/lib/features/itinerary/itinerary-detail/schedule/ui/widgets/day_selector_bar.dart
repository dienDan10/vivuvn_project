import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'day_selector_button.dart';

final selectedDayIndexProvider = StateProvider<int>((final ref) => 0);

final daysProvider = Provider<List<String>>((final ref) {
  return ['22/10', '23/10', '24/10', '25/10', '26/10', '25/10', '25/10'];
});

class DaySelectorBar extends ConsumerWidget {
  const DaySelectorBar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final days = ref.watch(daysProvider);
    final selectedIndex = ref.watch(selectedDayIndexProvider);

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
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DaySelectorButton(
                      label: days[index],
                      isSelected: selectedIndex == index,
                      onTap: () =>
                          ref.read(selectedDayIndexProvider.notifier).state =
                              index,
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
