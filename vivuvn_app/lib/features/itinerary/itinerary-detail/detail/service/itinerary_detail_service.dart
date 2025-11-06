import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view-itinerary-list/models/itinerary.dart';
import '../data/api/itinerary_detail_api.dart';

final itineraryDetailServiceProvider =
    Provider.autoDispose<ItineraryDetailService>((final ref) {
      final api = ref.watch(itineraryDetailApiProvider);
      return ItineraryDetailService(api);
    });

class ItineraryDetailService {
  final ItineraryDetailApi _api;
  ItineraryDetailService(this._api);

  Future<Itinerary> getItineraryDetail(final int id) async {
    return await _api.getItineraryDetail(id);
  }

  Future<void> updateGroupSize({
    required final int itineraryId,
    required final int groupSize,
  }) async {
    await _api.updateGroupSize(itineraryId: itineraryId, groupSize: groupSize);
  }

  Future<String> getInviteCode(final int itineraryId) async {
    return await _api.getInviteCode(itineraryId);
  }
}
