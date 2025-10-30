import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/data/remote/network/network_service.dart';
import '../../../model/location.dart';

final locationApiProvider = Provider.autoDispose<LocationApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return LocationApi(dio);
});

class LocationApi {
  final Dio _dio;
  LocationApi(this._dio);

  Future<Location> getLocationDetail(final int id) async {
    final response = await _dio.get('/api/v1/locations/$id');
    return Location.fromJson(response.data);
  }
}
