import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/add_hotel_expan.dart';
import 'widgets/add_place_button.dart';
import 'widgets/add_restaurant_expan.dart';
import 'widgets/day_selector_bar.dart';
import 'widgets/day_title.dart';
import 'widgets/place_list_section.dart';
import 'widgets/suggested_places_tile.dart';

class ScheduleTab extends ConsumerWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final days = ref.watch(daysProvider);
    final selectedIndex = ref.watch(selectedDayIndexProvider);
    final selectedDay = days[selectedIndex];

    return Column(
      children: [
        const DaySelectorBar(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Tiêu đề ngày
              DayTitle(day: selectedDay),

              // Danh sách địa điểm
              const PlaceListSection(),

              // Nút thêm địa điểm
              const AddPlaceButton(),

              // Các nhóm mở rộng (expand)
              const SuggestedPlacesTile(),
              const AddHotelTile(),
              const AddRestaurantTile(),
            ],
          ),
        ),
      ],
    );
  }
}
