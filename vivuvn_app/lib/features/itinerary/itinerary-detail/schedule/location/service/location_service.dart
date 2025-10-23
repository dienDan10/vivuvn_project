import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/location_api.dart';
import '../model/location_detail.dart';

final locationServiceProvider = Provider.autoDispose<LocationService>((
  final ref,
) {
  final api = ref.watch(locationApiProvider);
  return LocationService(api);
});

class LocationService {
  final LocationApi _api;
  LocationService(this._api);

  Future<LocationDetail> getLocationDetail(final int id) async {
    return await _api.getLocationDetail(id);
  }
}
