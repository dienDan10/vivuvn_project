// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../data/model/member.dart';

class MemberState {
  final List<Member> members;
  final bool isLoadingMembers;
  final String? loadingMembersError;
  final bool isKickingMember;
  final String? kickingMemberError;

  MemberState({
    this.members = const [],
    this.isLoadingMembers = false,
    this.loadingMembersError,
    this.isKickingMember = false,
    this.kickingMemberError,
  });

  MemberState copyWith({
    final List<Member>? members,
    final bool? isLoadingMembers,
    final String? loadingMembersError,
    final bool? isKickingMember,
    final String? kickingMemberError,
  }) {
    return MemberState(
      members: members ?? this.members,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      loadingMembersError: loadingMembersError,
      isKickingMember: isKickingMember ?? this.isKickingMember,
      kickingMemberError: kickingMemberError,
    );
  }
}
