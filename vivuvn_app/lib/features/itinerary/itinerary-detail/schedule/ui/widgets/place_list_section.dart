import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'add_place_button.dart';
import 'schedule_place_card.dart';
import 'transport_section.dart';

class PlaceListSection extends ConsumerWidget {
  const PlaceListSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);

    // Lấy danh sách ngày
    final days = state.days;
    if (days.isEmpty) {
      return const Center(child: Text('Không có ngày nào trong lịch trình.'));
    }

    // Lấy ngày được chọn
    final selectedDay = days[state.selectedIndex];
    final items = selectedDay.items;

    // Nếu chưa có địa điểm, chỉ hiển thị nút thêm địa điểm
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: AddPlaceButton(),
      );
    }

    // danh sách địa điểm
    return Column(
      children: [
        ...items.asMap().entries.map((final entry) {
          final index = entry.key;
          final item = entry.value;
          final location = item.location;
          if (location == null) return const SizedBox.shrink();

          return Column(
            children: [
              SchedulePlaceCard(index: index, location: location),
              if (index != items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TransportSection(index: index),
                ),
            ],
          );
        }),
        const SizedBox(height: 8),
        const AddPlaceButton(),
      ],
    );
  }
}
