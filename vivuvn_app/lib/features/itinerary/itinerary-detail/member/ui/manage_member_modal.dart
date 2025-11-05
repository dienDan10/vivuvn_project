import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/helper/image_util.dart';
import '../data/model/member.dart';
import 'kick_member_confirm_dialog.dart';

class ManageMemberModal extends ConsumerStatefulWidget {
  final Member member;
  const ManageMemberModal({super.key, required this.member});

  @override
  ConsumerState<ManageMemberModal> createState() => _ManageMemberModalState();
}

class _ManageMemberModalState extends ConsumerState<ManageMemberModal> {
  void _showKickConfirmationDialog() {
    showDialog(
      context: context,
      builder: (final context) =>
          KickMemberConfirmDialog(member: widget.member),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Member info header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  ImageUtil.buildAvatarWidget(
                    imageUrl: widget.member.photo,
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.member.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          widget.member.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),

            // Kick member option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_remove_outlined,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
              title: Text(
                'Xóa thành viên',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Xóa thành viên khỏi hành trình',
                style: TextStyle(fontSize: 12, color: colorScheme.outline),
              ),
              onTap: () {
                context.pop(context);
                _showKickConfirmationDialog();
              },
            ),

            // Cancel option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.close, color: colorScheme.outline, size: 20),
              ),
              title: Text(
                'Hủy',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => context.pop(context),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
