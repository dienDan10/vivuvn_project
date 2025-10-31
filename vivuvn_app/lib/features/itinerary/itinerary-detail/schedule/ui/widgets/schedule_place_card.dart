import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/itinerary_item.dart';
import 'place_card_details.dart';
import 'place_card_header.dart';

class SchedulePlaceCard extends ConsumerStatefulWidget {
  const SchedulePlaceCard({super.key, required this.item});

  final ItineraryItem item;

  @override
  ConsumerState<SchedulePlaceCard> createState() => _SchedulePlaceCardState();
}

class _SchedulePlaceCardState extends ConsumerState<SchedulePlaceCard> {
  bool isExpanded = false;

  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: PlaceCardHeader(item: widget.item),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 12),
            PlaceCardDetails(item: widget.item),
          ],
        ],
      ),
    );
  }
}
