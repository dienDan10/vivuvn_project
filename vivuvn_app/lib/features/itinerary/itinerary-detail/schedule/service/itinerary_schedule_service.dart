import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api/itinerary_schedule_api.dart';
import '../model/itinerary_day.dart';

final itineraryScheduleServiceProvider =
    Provider.autoDispose<ItineraryScheduleService>((final ref) {
  final api = ref.watch(itineraryScheduleApiProvider);
  return ItineraryScheduleService(api);
});

class ItineraryScheduleService {
  final ItineraryScheduleApi _api;
  ItineraryScheduleService(this._api);

  Future<List<ItineraryDay>> getItineraryDays(final int itineraryId) async {
    return await _api.getItineraryDays(itineraryId);
  }
}
