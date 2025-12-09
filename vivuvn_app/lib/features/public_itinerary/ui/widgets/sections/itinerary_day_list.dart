import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../../../../itinerary/itinerary-detail/schedule/ui/widgets/schedule_place_card.dart';

class ItineraryDayList extends StatefulWidget {
  final List<ItineraryDay> days;

  const ItineraryDayList({
    required this.days,
    super.key,
  });

  @override
  State<ItineraryDayList> createState() => _ItineraryDayListState();
}

class _ItineraryDayListState extends State<ItineraryDayList> {
  final Set<int> _expandedDays = {};

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        ...widget.days.map((final day) {
          final date = day.date;
          final dayLabel = date != null
              ? DateFormat('EEE, dd/MM/yyyy', 'vi').format(date)
              : 'Ngày ${day.dayNumber}';
          final isExpanded = _expandedDays.contains(day.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                dayLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${day.items.length} địa điểm',
                style: theme.textTheme.bodySmall,
              ),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary,
                child: Text(
                  '${day.dayNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (final expanded) {
                setState(() {
                  if (expanded) {
                    _expandedDays.add(day.id);
                  } else {
                    _expandedDays.remove(day.id);
                  }
                });
              },
              children: [
                if (day.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Chưa có địa điểm nào',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ...day.items.map(
                    (final item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: SchedulePlaceCard(item: item),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ],
    );
  }
}

