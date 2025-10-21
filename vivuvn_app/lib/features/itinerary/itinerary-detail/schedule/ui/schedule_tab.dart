import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/btn_ai_gen_itinerary.dart';
import '../controller/itinerary_schedule_controller.dart';
import 'widgets/add_hotel_expan.dart';
import 'widgets/add_restaurant_expan.dart';
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
    final scheduleState = ref.watch(itineraryScheduleControllerProvider);

    if (scheduleState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (scheduleState.error != null) {
      return Center(
        child: Text(
          'Lỗi: ${scheduleState.error}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final days = scheduleState.days;
    final selectedIndex = scheduleState.selectedIndex;
    final selectedDay = (days.isNotEmpty && selectedIndex < days.length)
        ? days[selectedIndex]
        : null;

    return Scaffold(
      body: selectedDay == null
          ? const Center(child: Text('Chưa có ngày nào trong lịch trình.'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const DayTitle(),
                  PlaceListSection(dayId: selectedDay.id),
                  SuggestedPlacesTile(dayId: selectedDay.id),
                  AddHotelTile(dayId: selectedDay.id),
                  AddRestaurantTile(dayId: selectedDay.id),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
      floatingActionButton: const ButtonGenerateItinerary(),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }
}
