import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'current_itinerary_provider.dart';

class ItineraryMainInfo extends ConsumerWidget {
  const ItineraryMainInfo({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(currentItineraryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Text(
          itinerary.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${DateFormat.MMMd('vi').format(itinerary.startDate)} - ${DateFormat.yMMMd('vi').format(itinerary.endDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


