import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../../../home/controller/home_controller.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../model/add_location_result.dart';
import '../model/itinerary_day.dart';
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
    final id = itineraryId;
    if (id == null) return;

    state = state.copyWith(isLoading: true, itineraryId: id);

    try {
      final days = await ref
          .read(itineraryScheduleServiceProvider)
          .getItineraryDays(id);

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
  Future<bool> addItemToDay(final int dayId, final int locationId) async {
    if (itineraryId == null) return false;
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .addItemToDay(itineraryId!, dayId, locationId);
      await fetchItemsByDay(dayId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // === Xóa item ===
  /// Trả về `true` nếu xóa thành công, `false` nếu có lỗi.
  Future<bool> deleteItem(final int itemId) async {
    if (itineraryId == null) return false;
    // get day id
    final dayId = state.days[state.selectedIndex].id;
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .deleteItemFromDay(itineraryId!, dayId, itemId);

      // remove item from state
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
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<AddLocationResult> addLocationToSelectedDay({
    required final int locationId,
    required final String locationName,
  }) async {
    final selectedDayId = state.selectedDayId;

    if (selectedDayId == null) {
      return AddLocationResult.failure('Vui lòng chọn ngày trước khi thêm địa điểm.');
    }

    final success = await addItemToDay(selectedDayId, locationId);

    if (success) {
      return AddLocationResult.success('Đã thêm "$locationName" vào lịch trình.');
    }

    return AddLocationResult.failure('Không thể thêm địa điểm vào lịch trình.');
  }

  // === State helper ===
  void selectDay(final int index) {
    if (index < 0 || index >= state.days.length) return;
    final selectedDayId = state.days[index].id;

    state = state.copyWith(selectedIndex: index, selectedDayId: selectedDayId);
  }

  Future<void> updateItem({
    required final int itemId,
    final String? note,
    final TimeOfDay? startTime,
    final TimeOfDay? endTime,
  }) async {
    if (itineraryId == null) return;
    // get day id
    final dayId = state.days[state.selectedIndex].id;
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

  Future<void> updateDates(final DateTime start, final DateTime end) async {
    if (itineraryId == null) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .updateItineraryDates(
            itineraryId: itineraryId!,
            startDate: start,
            endDate: end,
          );

      // load lại days
      await fetchDays();
      
      // Refresh itinerary detail to update dates in detail screen
      ref.read(itineraryDetailControllerProvider.notifier).fetchItineraryDetail();
      
      // Refresh home data to update "recent itineraries" section
      ref.read(homeControllerProvider.notifier).refreshHomeDataSilently();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchSuggestedLocations({
    final int? provinceId,
    final bool forceRefresh = false,
  }) async {
    final itineraryState = ref.read(itineraryDetailControllerProvider);
    final int? targetProvinceId = provinceId ??
        itineraryState.itinerary?.destinationProvinceId ??
        itineraryState.itinerary?.startProvinceId;

    if (targetProvinceId == null) {
      return;
    }

    if (!forceRefresh &&
        state.suggestedProvinceId == targetProvinceId &&
        state.suggestedLocations.isNotEmpty &&
        state.suggestedLocationsError == null) {
      return;
    }

    state = state.copyWith(
      isLoadingSuggestedLocations: true,
      suggestedLocationsError: null,
      suggestedProvinceId: targetProvinceId,
    );

    try {
      final locations = await ref
          .read(itineraryScheduleServiceProvider)
          .getSuggestedLocations(provinceId: targetProvinceId);

      state = state.copyWith(
        isLoadingSuggestedLocations: false,
        suggestedLocations: locations,
        suggestedProvinceId: targetProvinceId,
      );
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        isLoadingSuggestedLocations: false,
        suggestedLocationsError: errorMsg,
        suggestedProvinceId: targetProvinceId,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingSuggestedLocations: false,
        suggestedLocationsError: 'unknown error',
        suggestedProvinceId: targetProvinceId,
      );
    }
  }

  Future<void> updateTransportationVehicle({
    required final int itemId,
    required final String vehicle,
  }) async {
    if (itineraryId == null) return;
    // get day id
    final dayId = state.days[state.selectedIndex].id;
    state = state.copyWith(
      isLoadingUpdateTransportation: true,
      updateTransportationError: null,
    );
    try {
      final updatedItem = await ref
          .read(itineraryScheduleServiceProvider)
          .updateTransportationVehicle(
            itineraryId: itineraryId!,
            dayId: dayId,
            itemId: itemId,
            vehicle: vehicle,
          );

      // Cập nhật trực tiếp trong state mà không gọi API lại
      final updatedDays = state.days.map((final day) {
        if (day.id != dayId) return day;

        final updatedItems = day.items.map((final item) {
          if (item.itineraryItemId == updatedItem.itineraryItemId) {
            return updatedItem;
          }
          return item;
        }).toList();
        return day.copyWith(items: updatedItems);
      }).toList();

      state = state.copyWith(days: updatedDays);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        updateTransportationError: errorMsg,
        isLoadingUpdateTransportation: false,
      );
    } catch (e) {
      state = state.copyWith(
        updateTransportationError: 'unknown error',
        isLoadingUpdateTransportation: false,
      );
    } finally {
      state = state.copyWith(isLoadingUpdateTransportation: false);
    }
  }
}
