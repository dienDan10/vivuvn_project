import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detail/ui/btn_ai_gen_itinerary.dart';
import '../controller/itinerary_schedule_controller.dart';
import 'widgets/day_selector_bar.dart';
import 'widgets/day_title.dart';
import 'widgets/place_list_section.dart';
import 'widgets/suggested_places_tile.dart';

class ScheduleTab extends ConsumerStatefulWidget {
  const ScheduleTab({super.key});

  @override
  ConsumerState<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends ConsumerState<ScheduleTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itineraryScheduleControllerProvider.notifier).fetchDays();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final isLoading = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.isLoading,
      ),
    );
    final error = ref.watch(
      itineraryScheduleControllerProvider.select((final state) => state.error),
    );

    if (isLoading) {
      return Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: Center(
          child: Text(
            'Lỗi: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: const [
              DaySelectorBar(),
              DayTitle(),
              PlaceListSection(),
              SuggestedPlacesTile(),
              // AddHotelTile(),
              // AddRestaurantTile(),
              SizedBox(height: 80), // Space for FAB
            ],
          ),
          const Positioned(child: ButtonGenerateItinerary()),
        ],
      ),
    );
  }
}
