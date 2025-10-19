import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dto/add_item_to_day_request.dart';
import '../dto/get_items_by_day_response.dart';
import '../dto/get_itinerary_days_response.dart';

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
}
