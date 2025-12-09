import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/public_itinerary_controller.dart';
import 'widgets/hotel_item_card.dart';

class HotelSection extends ConsumerStatefulWidget {
  const HotelSection({super.key});

  @override
  ConsumerState<HotelSection> createState() => _HotelSectionState();
}

class _HotelSectionState extends ConsumerState<HotelSection> {
  bool _expanded = true;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final hotels = ref.watch(
      publicItineraryControllerProvider.select((final s) => s.hotels),
    );

    if (hotels.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Khách sạn',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() => _expanded = !_expanded);
                },
              ),
            ],
          ),
        ),
        if (_expanded)
          ...hotels.map(
            (final hotel) => HotelItemCard(hotel: hotel),
          ),
      ],
    );
  }
}

