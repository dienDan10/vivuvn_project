import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/search_province_api.dart';
import '../models/province.dart';
import 'icreate_itinerary_service.dart';

final createItineraryServiceProvider =
    Provider.autoDispose<IcreateItineraryService>((final ref) {
      final searchProvinceApi = ref.watch(searchProvinceApiProvider);
      return CreateItineraryService(searchProvinceApi);
    });

class CreateItineraryService implements IcreateItineraryService {
  final SearchProvinceApi _searchProvinceApi;
  CreateItineraryService(this._searchProvinceApi);

  @override
  Future<List<Province>> searchProvince(final String queryText) async {
    return await _searchProvinceApi.searchProvince(queryText);
  }
}
