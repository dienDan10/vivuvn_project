import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../overview/ui/place_card.dart';
import '../ui/btn_ai_gen_itinerary.dart';
import 'schedule_data.dart';
import 'ui/add_hotel_expan.dart';
import 'ui/add_place_bottom_sheet.dart';
import 'ui/add_place_button.dart';
import 'ui/add_restaurant_expan.dart';
import 'ui/add_suggested_places_expan.dart';
import 'ui/day_selector_bar.dart';
import 'ui/transport_section.dart';

class ScheduleTab extends ConsumerWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final days = ref.watch(daysProvider);
    final selectedIndex = ref.watch(selectedDayIndexProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DaySelectorBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  child: Text(
                    days[selectedIndex],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Danh sách địa điểm và phương tiện di chuyển mẫu
                ...samplePlaces.asMap().entries.map((final entry) {
                  final index = entry.key;
                  final place = entry.value;
                  return Column(
                    children: [
                      PlaceCard(
                        title: place.title,
                        description: place.description,
                      ),
                      if (index != samplePlaces.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: TransportSection(),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AddPlaceButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (final context) => const FractionallySizedBox(
                          heightFactor: 0.8,
                          child: AddPlaceBottomSheet(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Các ExpansionTile đã tách file
                const SuggestedPlacesTile(),
                const AddHotelTile(),
                const AddRestaurantTile(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const ButtonGenerateItinerary(),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }
}
