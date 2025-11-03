import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/member_controller.dart';
import 'member_item.dart';

class MemberList extends ConsumerWidget {
  const MemberList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final members = ref.watch(
      memberControllerProvider.select((final state) => state.members),
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        physics: const BouncingScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (final context, final index) {
          final member = members[index];
          return MemberItem(key: ValueKey(member.memberId), member: member);
        },
      ),
    );
  }
}
