import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';
import '../model/itinerary_day.dart';
import '../model/itinerary_item.dart';
import '../service/itinerary_schedule_service.dart';
import '../state/itinerary_schedule_state.dart';

final itineraryScheduleControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryScheduleController,
      ItineraryScheduleState
    >(ItineraryScheduleController.new);

class ItineraryScheduleController
    extends AutoDisposeNotifier<ItineraryScheduleState> {
  @override
  ItineraryScheduleState build() => ItineraryScheduleState();

  int? get itineraryId =>
      ref.read(itineraryDetailControllerProvider).itineraryId;

  // === Lấy danh sách ngày ===
  Future<void> fetchDays() async {
    state = state.copyWith(isLoading: true);

    try {
      final days = await ref
          .read(itineraryScheduleServiceProvider)
          .getItineraryDays(itineraryId!);

      state = state.copyWith(
        isLoading: false,
        days: days,
        selectedIndex: days.isNotEmpty ? 0 : -1,
        selectedDayId: days.isNotEmpty ? days.first.id : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // === Lấy items theo ngày ===
  Future<void> fetchItemsByDay(final int dayId) async {
    if (itineraryId == null) return;
    state = state.copyWith(isLoading: true);
    try {
      final items = await ref
          .read(itineraryScheduleServiceProvider)
          .getItemsByDay(itineraryId!, dayId);

      final updatedDays = state.days.map((final d) {
        if (d.id == dayId) {
          return ItineraryDay(
            id: d.id,
            dayNumber: d.dayNumber,
            date: d.date,
            items: items,
          );
        }
        return d;
      }).toList();

      state = state.copyWith(days: updatedDays, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // === Thêm item vào ngày ===
  Future<void> addItemToDay(final int dayId, final int locationId) async {
    if (itineraryId == null) return;
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .addItemToDay(itineraryId!, dayId, locationId);
      await fetchItemsByDay(dayId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // === Xóa item ===
  Future<void> deleteItem(final int dayId, final int itemId) async {
    if (itineraryId == null) return;
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .deleteItemFromDay(itineraryId!, dayId, itemId);

      final updatedDays = state.days.map((final day) {
        if (day.id == dayId) {
          final newItems = day.items
              .where((final i) => i.itineraryItemId != itemId)
              .toList();
          return ItineraryDay(
            id: day.id,
            dayNumber: day.dayNumber,
            date: day.date,
            items: newItems,
          );
        }
        return day;
      }).toList();

      state = state.copyWith(days: updatedDays);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // === State helper ===
  void selectDay(final int index) {
    if (index < 0 || index >= state.days.length) return;
    final selectedDayId = state.days[index].id;

    state = state.copyWith(selectedIndex: index, selectedDayId: selectedDayId);
  }

  void selectItem(final ItineraryItem item) =>
      state = state.copyWith(selectedItem: item);

  Future<void> updateItem({
    required final int dayId,
    required final int itemId,
    final String? note,
    final TimeOfDay? startTime,
    final TimeOfDay? endTime,
  }) async {
    if (itineraryId == null) return;
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .updateItem(
            itineraryId: itineraryId!,
            dayId: dayId,
            itemId: itemId,
            note: note,
            startTime: startTime,
            endTime: endTime,
          );

      // Cập nhật trực tiếp trong state mà không gọi API lại
      final updatedDays = state.days.map((final day) {
        if (day.id == dayId) {
          final updatedItems = day.items.map((final item) {
            if (item.itineraryItemId == itemId) {
              return item.copyWith(
                note: note,
                startTime: startTime,
                endTime: endTime,
              );
            }
            return item;
          }).toList();
          return day.copyWith(items: updatedItems);
        }
        return day;
      }).toList();

      state = state.copyWith(days: updatedDays);
      // refresh lại danh sách
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
