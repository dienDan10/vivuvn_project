import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/member_controller.dart';
import 'load_member_error.dart';
import 'member_list.dart';

class MemberTab extends ConsumerStatefulWidget {
  const MemberTab({super.key});

  @override
  ConsumerState<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends ConsumerState<MemberTab> {
  @override
  void initState() {
    super.initState();
    // Load members when the tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberControllerProvider.notifier).loadMembers();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final members = ref.watch(
      memberControllerProvider.select((final state) => state.members),
    );
    final isLoading = ref.watch(
      memberControllerProvider.select((final state) => state.isLoadingMembers),
    );
    final loadingError = ref.watch(
      memberControllerProvider.select(
        (final state) => state.loadingMembersError,
      ),
    );

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.onPrimary),
      );
    }

    if (loadingError != null) {
      return const LoadMemberError();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // number of members
              Row(
                children: [
                  Icon(Icons.group, color: colorScheme.onPrimary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${members.length}',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // chat icons
              Icon(Icons.chat, color: colorScheme.onPrimary, size: 24),
            ],
          ),
        ),

        // list of members
        const Expanded(child: MemberList()),
      ],
    );
  }
}
