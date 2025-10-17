import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/itinerary_api.dart';
import '../models/itinerary.dart';

final itineraryServiceProvider = Provider.autoDispose<ItineraryService>((
  final ref,
) {
  final api = ref.watch(itineraryApiProvider);
  return ItineraryService(api);
});

class ItineraryService {
  final ItineraryApi _api;
  ItineraryService(this._api);

  Future<List<Itinerary>> getItineraries() async {
    return await _api.getItineraries();
  }
}
