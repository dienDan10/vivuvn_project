import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/public_itinerary_controller.dart';
import 'widgets/itinerary_day_tile.dart';

class ItineraryDayList extends ConsumerStatefulWidget {
  const ItineraryDayList({super.key});

  @override
  ConsumerState<ItineraryDayList> createState() => _ItineraryDayListState();
}

class _ItineraryDayListState extends ConsumerState<ItineraryDayList> {
  final Set<int> _expandedDays = {};

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final days = ref.watch(
      publicItineraryControllerProvider.select((final s) => s.days),
    );

    if (days.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Lịch trình',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...days.map((final day) {
          final isExpanded = _expandedDays.contains(day.id);
          return ItineraryDayTile(
            day: day,
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                if (isExpanded) {
                  _expandedDays.remove(day.id);
                } else {
                  _expandedDays.add(day.id);
                }
              });
            },
          );
        }),
      ],
    );
  }
}

