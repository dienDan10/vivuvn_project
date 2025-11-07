import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';

class SuggestedPlacesError extends ConsumerWidget {
  const SuggestedPlacesError({super.key, required this.message});

  final String message;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              final lastProvinceId = ref.read(
                itineraryScheduleControllerProvider.select(
                  (final state) => state.suggestedProvinceId,
                ),
              );

              ref
                  .read(itineraryScheduleControllerProvider.notifier)
                  .fetchSuggestedLocations(
                    provinceId: lastProvinceId,
                    forceRefresh: true,
                  );
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

