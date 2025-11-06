import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';
import 'itinerary_name_display.dart';
import 'itinerary_name_input.dart';

class ItineraryNameEditor extends ConsumerWidget {
  const ItineraryNameEditor({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary,
      ),
    );
    final isEditing = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.isNameEditing,
      ),
    );

    if (itinerary == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        if (!itinerary.isOwner) return;
        ref.read(itineraryDetailControllerProvider.notifier).startNameEditing();
      },
      child: isEditing
          ? const ItineraryNameInput()
          : const ItineraryNameDisplay(),
    );
  }
}
