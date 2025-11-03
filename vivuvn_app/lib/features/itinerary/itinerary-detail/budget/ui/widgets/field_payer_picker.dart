import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../member/controller/member_controller.dart';
import '../../../member/data/model/member.dart';
import '../../state/expense_form_notifier.dart';

class FieldPayerPicker extends ConsumerStatefulWidget {
  const FieldPayerPicker({super.key});

  @override
  ConsumerState<FieldPayerPicker> createState() => _FieldPayerPickerState();
}

class _FieldPayerPickerState extends ConsumerState<FieldPayerPicker> {
  Future<void> _openPayerBottomSheet(final BuildContext context) async {
    final membersState = ref.read(memberControllerProvider);
    final formNotifier = ref.read(expenseFormProvider.notifier);

    if (membersState.members.isEmpty && !membersState.isLoadingMembers) {
      await ref.read(memberControllerProvider.notifier).loadMembers();
    }

    // Show bottom sheet
    final selectedId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final ctx) {
        final theme = Theme.of(ctx);
        final state = ref.watch(memberControllerProvider);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Chọn người trả',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                if (state.isLoadingMembers)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.loadingMembersError != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.loadingMembersError!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: () => ref.read(memberControllerProvider.notifier).loadMembers(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.members.length + 1,
                      separatorBuilder: (final _, final __) => const Divider(height: 1),
                      itemBuilder: (final context, final index) {
                        final formState = ref.watch(expenseFormProvider);
                        if (index == 0) {
                          final bool isSelectedNone = formState.payerMemberId == null;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.person_off),
                            ),
                            title: const Text('Không ai trả'),
                            trailing: isSelectedNone
                                ? Icon(Icons.check, color: theme.colorScheme.primary)
                                : null,
                            selected: isSelectedNone,
                            onTap: () {
                              ref.read(expenseFormProvider.notifier).setPayer(null, null);
                              Navigator.of(context).pop();
                            },
                          );
                        }

                        final m = state.members[index - 1];
                        final isSelected = formState.payerMemberId == m.memberId;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            backgroundImage: (m.photo != null && m.photo!.isNotEmpty)
                                ? NetworkImage(m.photo!)
                                : null,
                            child: (m.photo == null || m.photo!.isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(m.username),
                          trailing: isSelected
                              ? Icon(Icons.check, color: theme.colorScheme.primary)
                              : null,
                          selected: isSelected,
                          onTap: () => Navigator.of(context).pop<int>(m.memberId),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedId != null) {
      final chosen = ref.read(memberControllerProvider).members.firstWhere(
            (final m) => m.memberId == selectedId,
            orElse: () => null as dynamic,
          ) as Member?;
      formNotifier.setPayer(selectedId, chosen?.username);
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(memberControllerProvider).members;
      if (members.isEmpty) {
        ref.read(memberControllerProvider.notifier).loadMembers();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final membersState = ref.watch(memberControllerProvider);
    final formState = ref.watch(expenseFormProvider);

    // Find selected member
    Member? selectedMember;
    if (formState.payerMemberId != null) {
      for (final m in membersState.members) {
        if (m.memberId == formState.payerMemberId) {
          selectedMember = m;
          break;
        }
      }
    }

    return InkWell(
      onTap: membersState.isLoadingMembers ? null : () => _openPayerBottomSheet(context),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Chọn người trả',
          border: OutlineInputBorder(),
        ),
        child: Row(
          children: [
            if (selectedMember != null)
              Builder(
                builder: (final context) {
                  final member = selectedMember!;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        backgroundImage: (member.photo != null && member.photo!.isNotEmpty)
                            ? NetworkImage(member.photo!)
                            : null,
                        child: (member.photo == null || member.photo!.isEmpty)
                            ? const Icon(Icons.person, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 8),
                    ],
                  );
                },
              ),
            Expanded(
              child: Text(
                formState.payerMemberId == null
                    ? 'Không ai trả'
                    : (selectedMember?.username ?? formState.payerMemberName ?? 'Nhấn để chọn'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: (selectedMember == null && formState.payerMemberId != null && formState.payerMemberName == null)
                          ? Theme.of(context).hintColor
                          : null,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_up),
          ],
        ),
      ),
    );
  }
}


