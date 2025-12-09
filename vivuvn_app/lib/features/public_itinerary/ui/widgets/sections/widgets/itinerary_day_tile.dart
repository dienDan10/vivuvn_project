import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../../../../../itinerary/itinerary-detail/schedule/ui/widgets/schedule_place_card.dart';

class ItineraryDayTile extends StatelessWidget {
  final ItineraryDay day;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ItineraryDayTile({
    required this.day,
    required this.isExpanded,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final date = day.date;
    final dayLabel = date != null
        ? DateFormat('EEE, dd/MM/yyyy', 'vi').format(date)
        : 'Ngày ${day.dayNumber}';

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
        onExpansionChanged: (final _) => onToggle(),
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
  }
}

