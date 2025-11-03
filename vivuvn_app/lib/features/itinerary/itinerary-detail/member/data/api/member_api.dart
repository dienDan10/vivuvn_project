import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../model/member.dart';

class MemberApi {
  final Dio _dio;
  MemberApi(this._dio);

  Future<List<Member>> getMembers(final int itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/members');

    final data = response.data as List<dynamic>;
    return data
        .map((final e) => Member.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}

final memberApiProvider = Provider.autoDispose<MemberApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return MemberApi(dio);
});
