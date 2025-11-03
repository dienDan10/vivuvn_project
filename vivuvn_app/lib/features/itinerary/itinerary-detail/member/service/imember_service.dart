import '../data/model/member.dart';

abstract interface class IMemberService {
  Future<List<Member>> fetchMembers(final int itineraryId);
}
