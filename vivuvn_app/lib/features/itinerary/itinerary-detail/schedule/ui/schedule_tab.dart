import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/btn_ai_gen_itinerary.dart';
import '../controller/itinerary_schedule_controller.dart';
import 'widgets/add_hotel_expan.dart';
import 'widgets/add_place_button.dart';
import 'widgets/add_restaurant_expan.dart';
import 'widgets/day_selector_bar.dart';
import 'widgets/day_title.dart';
import 'widgets/place_list_section.dart';
import 'widgets/suggested_places_tile.dart';

class ScheduleTab extends ConsumerStatefulWidget {
  final int? itineraryId; // <-- cho phép null để kiểm tra

  const ScheduleTab({super.key, required this.itineraryId});

  @override
  ConsumerState<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends ConsumerState<ScheduleTab> {
  @override
  void initState() {
    super.initState();
    // gọi fetchDays khi mount
    Future.microtask(() {
      ref
          .read(itineraryScheduleControllerProvider.notifier)
          .fetchDays(widget.itineraryId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(itineraryScheduleControllerProvider);

    if (widget.itineraryId == null) {
      return const Center(
        child: Text('Thiếu itineraryId, không thể tải lịch trình.'),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          'Lỗi: ${state.error}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final days = state.days;
    final selectedIndex = state.selectedIndex;
    final selectedDay = (days.isNotEmpty && selectedIndex < days.length)
        ? days[selectedIndex]
        : null;

    return Scaffold(
      body: Column(
        children: [
          const DaySelectorBar(),
          Expanded(
            child: selectedDay == null
                ? const Center(
                    child: Text('Chưa có ngày nào trong lịch trình.'),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DayTitle(
                        day:
                            'Ngày ${selectedDay.dayNumber} - ${selectedDay.date?.day}/${selectedDay.date?.month}',
                      ),
                      const PlaceListSection(),
                      const AddPlaceButton(),
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
