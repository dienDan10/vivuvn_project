import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/update_itinerary_api.dart';

final updateItineraryServiceProvider =
    Provider.autoDispose<UpdateItineraryService>((final ref) {
  final api = ref.watch(updateItineraryApiProvider);
  return UpdateItineraryService(api);
});

class UpdateItineraryService {
  final UpdateItineraryApi _api;
  UpdateItineraryService(this._api);

  Future<void> updateName({
    required final int itineraryId,
    required final String name,
  }) async {
    await _api.updateName(itineraryId: itineraryId, name: name);
  }

  Future<void> setPublic({
    required final int itineraryId,
  }) async {
    await _api.setPublic(itineraryId: itineraryId);
  }

  Future<void> setPrivate({
    required final int itineraryId,
  }) async {
    await _api.setPrivate(itineraryId: itineraryId);
  }
}


