import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/day_selector_bar.dart';

class ScheduleTab extends ConsumerWidget {
  const ScheduleTab({super.key});
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final days = ref.watch(daysProvider);
    final selectedIndex = ref.watch(selectedDayIndexProvider);
    return Column(
      children: [
        const DaySelectorBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                days[selectedIndex],
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Nội dung của ngày ${days[selectedIndex]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
