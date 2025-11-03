// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../data/model/member.dart';

class MemberState {
  final List<Member> members;
  final bool isLoadingMembers;
  final String? loadingMembersError;

  MemberState({
    this.members = const [],
    this.isLoadingMembers = false,
    this.loadingMembersError,
  });

  MemberState copyWith({
    final List<Member>? members,
    final bool? isLoadingMembers,
    final String? loadingMembersError,
  }) {
    return MemberState(
      members: members ?? this.members,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      loadingMembersError: loadingMembersError ?? this.loadingMembersError,
    );
  }
}
