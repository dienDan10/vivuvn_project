import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/create_itinerary_api.dart';
import '../data/dto/create_itinerary_request.dart';
import '../data/dto/create_itinerary_response.dart';
import '../models/province.dart';
import 'icreate_itinerary_service.dart';

final createItineraryServiceProvider =
    Provider.autoDispose<IcreateItineraryService>((final ref) {
      final createItineraryApi = ref.watch(createItineraryApiProvider);
      return CreateItineraryService(createItineraryApi);
    });

class CreateItineraryService implements IcreateItineraryService {
  final CreateItineraryApi _createItineraryApi;
  CreateItineraryService(this._createItineraryApi);

  @override
  Future<List<Province>> searchProvince(final String queryText) async {
    return await _createItineraryApi.searchProvince(queryText);
  }

  @override
  Future<CreateItineraryResponse> createItinerary(
    final CreateItineraryRequest request,
  ) async {
    return await _createItineraryApi.createItinerary(request);
  }
}
