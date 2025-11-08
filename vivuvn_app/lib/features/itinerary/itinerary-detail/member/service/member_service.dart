import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/member_api.dart';
import '../data/dto/send_notification_request.dart';
import '../data/model/member.dart';
import 'imember_service.dart';

class MemberService implements IMemberService {
  final MemberApi _api;
  MemberService(this._api);

  @override
  Future<List<Member>> fetchMembers(final int itineraryId) async {
    return await _api.getMembers(itineraryId);
  }

  @override
  Future<void> kickMember(final int itineraryId, final int memberId) async {
    return await _api.kickMember(itineraryId, memberId);
  }

  @override
  Future<void> sendNotification(
    final int itineraryId,
    final String title,
    final String message, {
    final bool? sendEmail = false,
  }) async {
    final request = SendNotificationRequest(
      title: title,
      message: message,
      sendEmail: sendEmail,
    );
    await _api.sendNotification(itineraryId, request);
  }
}

final memberServiceProvider = Provider.autoDispose<IMemberService>((final ref) {
  final api = ref.watch(memberApiProvider);
  return MemberService(api);
});
