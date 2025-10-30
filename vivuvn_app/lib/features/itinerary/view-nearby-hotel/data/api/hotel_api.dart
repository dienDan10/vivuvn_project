import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../../model/hotel.dart';

class HotelApi {
  final Dio _dio;
  HotelApi(this._dio);

  Future<List<Hotel>> fetchNearbyHotels(final int locationId) async {
    final response = await _dio.get('/api/v1/locations/$locationId/hotels');

    final data = response.data as List<dynamic>;
    return data.map((final item) => Hotel.fromMap(item)).toList();
  }
}

final hotelApiProvider = Provider.autoDispose<HotelApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return HotelApi(dio);
});
