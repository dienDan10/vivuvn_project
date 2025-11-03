import '../data/model/member.dart';

abstract interface class IMemberService {
  Future<List<Member>> fetchMembers(final int itineraryId);
  Future<void> kickMember(final int itineraryId, final int memberId);
}
