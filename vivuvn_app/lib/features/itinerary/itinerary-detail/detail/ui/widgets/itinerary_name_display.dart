import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class ItineraryNameDisplay extends ConsumerWidget {
  const ItineraryNameDisplay({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final name = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.name ?? '',
      ),
    );

    return Text(
      name,
      textAlign: TextAlign.left,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}


