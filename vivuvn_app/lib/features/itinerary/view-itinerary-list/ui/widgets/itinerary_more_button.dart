import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_itinerary_provider.dart';
import 'edit_itinerary_modal.dart';

class ItineraryMoreButton extends ConsumerWidget {
  const ItineraryMoreButton({super.key});

  void _showBottomSheet(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.read(currentItineraryProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (final BuildContext ctx) {
        return EditItineraryModal(itinerary: itinerary);
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: const Icon(Icons.more_vert_outlined, size: 32.0),
        onTap: () => _showBottomSheet(context, ref),
      ),
    );
  }
}


