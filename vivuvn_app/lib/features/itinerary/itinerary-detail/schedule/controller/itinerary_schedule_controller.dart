import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../controller/itinerary_detail_controller.dart';
import '../model/itinerary_day.dart';
import '../service/itinerary_schedule_service.dart';
import '../state/itinerary_schedule_state.dart';

final itineraryScheduleControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryScheduleController,
      ItineraryScheduleState
    >(() => ItineraryScheduleController());

class ItineraryScheduleController
    extends AutoDisposeNotifier<ItineraryScheduleState> {
  @override
  ItineraryScheduleState build() => ItineraryScheduleState();

  // Lấy danh sách ngày
  Future<void> fetchDays() async {
    final itineraryId = ref.read(
      itineraryDetailControllerProvider.select(
        (final state) => state.itineraryId,
      ),
    );

    state = state.copyWith(itineraryId: itineraryId);

    state = state.copyWith(
      itineraryId: itineraryId,
      isLoading: true,
      error: null,
    );
    try {
      final data = await ref
          .read(itineraryScheduleServiceProvider)
          .getItineraryDays(state.itineraryId!);
      state = state.copyWith(days: data, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        error: DioExceptionHandler.handleException(e),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Lấy item theo ngày
  Future<void> fetchItemsByDay(final int itineraryId, final int dayId) async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await ref
          .read(itineraryScheduleServiceProvider)
          .getItemsByDay(itineraryId, dayId);
      final updatedDays = state.days.map((final day) {
        if (day.id == dayId) {
          return ItineraryDay(
            id: day.id,
            dayNumber: day.dayNumber,
            date: day.date,
            items: items,
          );
        }
        return day;
      }).toList();

      state = state.copyWith(days: updatedDays, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        error: DioExceptionHandler.handleException(e),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Thêm item vào ngày rồi fetch lại
  Future<void> addItem(
    final int itineraryId,
    final int dayId,
    final int locationId,
  ) async {
    try {
      await ref
          .read(itineraryScheduleServiceProvider)
          .addItemToDay(itineraryId, dayId, locationId);
      await fetchItemsByDay(itineraryId, dayId); // load lại danh sách
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void selectDay(final int index) {
    state = state.copyWith(selectedIndex: index);
  }

  Future<void> deleteItem(
    final int itineraryId,
    final int dayId,
    final int itemId,
  ) async {
    try {
      // Gọi API để xóa trên server
      await ref
          .read(itineraryScheduleServiceProvider)
          .deleteItemFromDay(itineraryId, dayId, itemId);

      // Cập nhật local state
      final updatedDays = state.days.map((final day) {
        if (day.id == dayId) {
          final updatedItems = day.items
              .where((final item) => item.itineraryItemId != itemId)
              .toList();

          return ItineraryDay(
            id: day.id,
            dayNumber: day.dayNumber,
            date: day.date,
            items: updatedItems,
          );
        }
        return day;
      }).toList();

      state = state.copyWith(days: updatedDays);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
