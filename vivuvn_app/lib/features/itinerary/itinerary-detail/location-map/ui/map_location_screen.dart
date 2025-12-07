import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../schedule/controller/itinerary_schedule_controller.dart';
import '../controller/map_location_controller.dart';
import 'location_carousel.dart';
import 'map_location.dart';

class MapLocationScreen extends ConsumerStatefulWidget {
  const MapLocationScreen({super.key});

  @override
  ConsumerState<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends ConsumerState<MapLocationScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize any required data or controllers here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itineraryDays = ref.read(
        itineraryScheduleControllerProvider.select((final state) => state.days),
      );
      final selectedIndex = ref.read(
        itineraryScheduleControllerProvider.select(
          (final state) => state.selectedIndex,
        ),
      );
      ref.read(mapLocationControllerProvider.notifier).setDays(itineraryDays);
      ref
          .read(mapLocationControllerProvider.notifier)
          .setSelectedIndex(selectedIndex);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final days = ref.watch(
      mapLocationControllerProvider.select((final state) => state.days),
    );

    if (days.isEmpty) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return const Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MapLocation(),

            // location carousel
            LocationCarousel(),
          ],
        ),
      ),
    );
  }
}
