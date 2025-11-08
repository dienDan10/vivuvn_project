import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class ItineraryDateRange extends ConsumerWidget {
  const ItineraryDateRange({super.key});

  String _formatDate(final DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final startDate = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.startDate,
      ),
    );
    final endDate = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.endDate,
      ),
    );

    if (startDate == null || endDate == null) {
      return const SizedBox.shrink();
    }

    return Text(
      '${_formatDate(startDate)} → ${_formatDate(endDate)}',
      style: const TextStyle(color: Colors.white70, fontSize: 16),
    );
  }
}

