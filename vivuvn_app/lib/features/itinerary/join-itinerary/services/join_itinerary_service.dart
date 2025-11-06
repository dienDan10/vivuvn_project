import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/join_itinerary_api.dart';
import 'ijoin_itinerary_service.dart';

final joinItineraryServiceProvider =
    Provider.autoDispose<IJoinItineraryService>((final ref) {
  final api = ref.watch(joinItineraryApiProvider);
  return JoinItineraryService(api);
});

class JoinItineraryService implements IJoinItineraryService {
  final JoinItineraryApi _api;
  JoinItineraryService(this._api);

  @override
  Future<void> joinByInviteCode(final String inviteCode) async {
    await _api.joinByInviteCode(inviteCode);
  }
}


