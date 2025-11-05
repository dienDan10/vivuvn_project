import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../../models/location.dart';

final searchLocationApiProvider = Provider.autoDispose<SearchLocationApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return SearchLocationApi(dio);
});

class SearchLocationApi {
  final Dio _dio;

  SearchLocationApi(this._dio);

  Future<List<Location>> searchLocations(final String queryText) async {
    if (queryText.isEmpty) return [];

    final response = await _dio.get('/api/v1/locations/search?name=$queryText');

    if (response.data == null) return [];

    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => Location.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
