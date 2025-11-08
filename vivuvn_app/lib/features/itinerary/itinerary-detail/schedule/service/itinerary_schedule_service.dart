import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/itinerary_schedule_api.dart';
import '../data/dto/add_item_to_day_request.dart';
import '../data/dto/update_item_request.dart';
import '../data/dto/update_transportation_request.dart';
import '../model/itinerary_day.dart';
import '../model/itinerary_item.dart';
import '../model/location.dart';

final itineraryScheduleServiceProvider =
    Provider.autoDispose<ItineraryScheduleService>((final ref) {
      final api = ref.watch(itineraryScheduleApiProvider);
      return ItineraryScheduleService(api);
    });

class ItineraryScheduleService {
  final ItineraryScheduleApi _api;
  ItineraryScheduleService(this._api);

  /// Lấy danh sách ngày
  Future<List<ItineraryDay>> getItineraryDays(final int itineraryId) async {
    final response = await _api.getItineraryDays(itineraryId);
    return response.days;
  }

  /// Lấy danh sách item theo ngày
  Future<List<ItineraryItem>> getItemsByDay(
    final int itineraryId,
    final int dayId,
  ) async {
    final response = await _api.getItemsByDay(itineraryId, dayId);
    return response.items;
  }

  /// Thêm item vào ngày
  Future<void> addItemToDay(
    final int itineraryId,
    final int dayId,
    final int locationId,
  ) async {
    final request = AddItemToDayRequest(locationId: locationId);
    await _api.addItemToDay(
      itineraryId: itineraryId,
      dayId: dayId,
      request: request,
    );
  }

  /// Xóa item khỏi ngày
  Future<void> deleteItemFromDay(
    final int itineraryId,
    final int dayId,
    final int itemId,
  ) async {
    await _api.deleteItemFromDay(
      itineraryId: itineraryId,
      dayId: dayId,
      itemId: itemId,
    );
  }

  /// Cập nhật item (note, startTime, endTime)
  Future<void> updateItem({
    required final int itineraryId,
    required final int dayId,
    required final int itemId,
    final String? note,
    final TimeOfDay? startTime,
    final TimeOfDay? endTime,
  }) async {
    final request = UpdateItemRequest(
      note: note,
      startTime: startTime,
      endTime: endTime,
    );

    await _api.updateItem(
      itineraryId: itineraryId,
      dayId: dayId,
      itemId: itemId,
      request: request,
    );
  }

  /// Update dates
  Future<void> updateItineraryDates({
    required final int itineraryId,
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    await _api.updateItineraryDates(
      itineraryId: itineraryId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // update transportation vehicle
  Future<ItineraryItem> updateTransportationVehicle({
    required final int itineraryId,
    required final int dayId,
    required final int itemId,
    required final String vehicle,
  }) async {
    final request = UpdateTransportationRequest(travelMode: vehicle);

    final updatedItem = await _api.updateTransportationVehicle(
      itineraryId: itineraryId,
      dayId: dayId,
      itemId: itemId,
      request: request,
    );
    return updatedItem;
  }

  Future<List<Location>> getSuggestedLocations({
    required final int provinceId,
    final int pageNumber = 1,
    final int pageSize = 5,
  }) async {
    final response = await _api.getSuggestedLocations(
      provinceId: provinceId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    return response.locations;
  }
}
