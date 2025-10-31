import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary-detail/schedule/model/location.dart';
import '../data/api/location_api.dart';

final locationServiceProvider = Provider.autoDispose<LocationService>((
  final ref,
) {
  final api = ref.watch(locationApiProvider);
  return LocationService(api);
});

class LocationService {
  final LocationApi _api;
  LocationService(this._api);

  Future<Location> getLocationDetail(final int id) async {
    return await _api.getLocationDetail(id);
  }
}
