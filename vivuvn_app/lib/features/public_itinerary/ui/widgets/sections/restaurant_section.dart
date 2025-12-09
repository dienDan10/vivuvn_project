import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/public_itinerary_controller.dart';
import 'widgets/restaurant_item_card.dart';

class RestaurantSection extends ConsumerStatefulWidget {
  const RestaurantSection({super.key});

  @override
  ConsumerState<RestaurantSection> createState() => _RestaurantSectionState();
}

class _RestaurantSectionState extends ConsumerState<RestaurantSection> {
  bool _expanded = true;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final restaurants = ref.watch(
      publicItineraryControllerProvider.select((final s) => s.restaurants),
    );

    if (restaurants.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Nhà hàng',
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
          ...restaurants.map(
            (final restaurant) => RestaurantItemCard(restaurant: restaurant),
          ),
      ],
    );
  }
}

