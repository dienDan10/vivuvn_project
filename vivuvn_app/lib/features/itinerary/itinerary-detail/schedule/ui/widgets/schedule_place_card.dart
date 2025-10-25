import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/place_expand_controller.dart';
import '../../model/location.dart';
import 'place_card_details.dart';
import 'place_card_header.dart';

class SchedulePlaceCard extends ConsumerWidget {
  const SchedulePlaceCard({
    super.key,
    required this.dayId,
    required this.index,
    required this.location,
  });

  final int dayId;
  final int index;
  final Location location;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final expandState = ref.watch(
      placeExpandControllerProvider((dayId, index)),
    );
    final controller = ref.read(
      placeExpandControllerProvider((dayId, index)).notifier,
    );

    return GestureDetector(
      onTap: controller.toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaceCardHeader(location: location),
            if (expandState.isExpanded) ...[
              const SizedBox(height: 12),
              PlaceCardDetails(location: location),
            ],
          ],
        ),
      ),
    );
  }
}
