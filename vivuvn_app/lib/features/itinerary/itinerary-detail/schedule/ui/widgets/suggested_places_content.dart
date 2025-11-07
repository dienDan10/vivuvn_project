import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'suggested_places_empty.dart';
import 'suggested_places_error.dart';
import 'suggested_places_list.dart';
import 'suggested_places_loading.dart';

class SuggestedPlacesContent extends ConsumerWidget {
  const SuggestedPlacesContent({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.isLoadingSuggestedLocations,
      ),
    );

    if (isLoading) {
      return const SuggestedPlacesLoading();
    }

    final error = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.suggestedLocationsError,
      ),
    );

    if (error != null) {
      return SuggestedPlacesError(message: error);
    }

    final hasSuggestions = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.suggestedLocations.isNotEmpty,
      ),
    );

    if (!hasSuggestions) {
      return const SuggestedPlacesEmpty();
    }

    return const SuggestedPlacesList();
  }
}
