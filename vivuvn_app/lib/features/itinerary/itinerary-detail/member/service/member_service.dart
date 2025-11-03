import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/member_api.dart';
import '../data/model/member.dart';
import 'imember_service.dart';

class MemberService implements IMemberService {
  final MemberApi _api;
  MemberService(this._api);

  @override
  Future<List<Member>> fetchMembers(final int itineraryId) async {
    return await _api.getMembers(itineraryId);
  }
}

final memberServiceProvider = Provider.autoDispose<IMemberService>((final ref) {
  final api = ref.watch(memberApiProvider);
  return MemberService(api);
});
