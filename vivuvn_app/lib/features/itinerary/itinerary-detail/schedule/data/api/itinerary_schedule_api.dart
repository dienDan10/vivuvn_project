import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../../model/itinerary_item.dart';
import '../dto/add_item_to_day_request.dart';
import '../dto/get_items_by_day_response.dart';
import '../dto/get_itinerary_days_response.dart';
import '../dto/get_locations_response.dart';
import '../dto/update_item_request.dart';
import '../dto/update_transportation_request.dart';

final itineraryScheduleApiProvider = Provider.autoDispose<ItineraryScheduleApi>(
  (final ref) {
    final dio = ref.watch(networkServiceProvider);
    return ItineraryScheduleApi(dio);
  },
);

class ItineraryScheduleApi {
  final Dio _dio;
  ItineraryScheduleApi(this._dio);

  /// GET: Danh sách ngày của itinerary
  Future<GetItineraryDaysResponse> getItineraryDays(
    final int itineraryId,
  ) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/days');
    return GetItineraryDaysResponse.fromJson(response.data as List<dynamic>);
  }

  /// GET: Danh sách item theo ngày
  Future<GetItemsByDayResponse> getItemsByDay(
    final int itineraryId,
    final int dayId,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items',
    );
    return GetItemsByDayResponse.fromJson(response.data as List<dynamic>);
  }

  /// POST: Thêm item vào ngày
  Future<void> addItemToDay({
    required final int itineraryId,
    required final int dayId,
    required final AddItemToDayRequest request,
  }) async {
    await _dio.post(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items',
      data: request.toJson(),
    );
  }

  /// DELETE: Xóa item trong ngày
  Future<void> deleteItemFromDay({
    required final int itineraryId,
    required final int dayId,
    required final int itemId,
  }) async {
    await _dio.delete(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items/$itemId',
    );
  }

  /// PUT: Cập nhật item trong ngày
  Future<void> updateItem({
    required final int itineraryId,
    required final int dayId,
    required final int itemId,
    required final UpdateItemRequest request,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items/$itemId',
      data: request.toJson(),
    );
  }

  /// PUT: Cập nhật startDate / endDate
  Future<void> updateItineraryDates({
    required final int itineraryId,
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final request = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
    await _dio.put('/api/v1/itineraries/$itineraryId/dates', data: request);
  }

  /// PUT: update transportation vehicle for an itinerary item
  Future<ItineraryItem> updateTransportationVehicle({
    required final int itineraryId,
    required final int dayId,
    required final int itemId,
    required final UpdateTransportationRequest request,
  }) async {
    final response = await _dio.put(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items/$itemId/routes',
      data: request.toJson(),
    );
    return ItineraryItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GetLocationsResponse> getSuggestedLocations({
    required final int provinceId,
    final int pageNumber = 1,
    final int pageSize = 5,
    final String sortBy = 'Rating',
    final bool isDescending = true,
  }) async {
    final response = await _dio.get(
      '/api/v1/locations',
      queryParameters: {
        'provinceId': provinceId,
        'sortBy': sortBy,
        'isDescending': isDescending,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    return GetLocationsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
