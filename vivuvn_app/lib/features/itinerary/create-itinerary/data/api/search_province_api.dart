import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../../models/province.dart';

final searchProvinceApiProvider = Provider.autoDispose<SearchProvinceApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return SearchProvinceApi(dio);
});

final class SearchProvinceApi {
  final Dio _dio;

  SearchProvinceApi(this._dio);

  Future<List<Province>> searchProvince(final String queryText) async {
    final response = await _dio.get<List<Province>>(
      '/api/v1/provinces/search?name=$queryText',
    );

    return response.data ?? [];
  }
}
