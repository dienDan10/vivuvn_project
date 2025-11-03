import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/toast/global_toast.dart';
import '../controller/member_controller.dart';
import '../data/model/member.dart';

class KickMemberConfirmDialog extends ConsumerStatefulWidget {
  final Member member;
  const KickMemberConfirmDialog({super.key, required this.member});

  @override
  ConsumerState<KickMemberConfirmDialog> createState() =>
      _KickMemberConfirmDialogState();
}

class _KickMemberConfirmDialogState
    extends ConsumerState<KickMemberConfirmDialog> {
  void _kickMember() async {
    await ref
        .read(memberControllerProvider.notifier)
        .kickMember(widget.member.memberId);
    if (mounted) context.pop();
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isKicking = ref.watch(
      memberControllerProvider.select((final state) => state.isKickingMember),
    );

    ref.listen(
      memberControllerProvider.select(
        (final state) => state.kickingMemberError,
      ),
      (final previous, final next) {
        if (next != null && mounted) {
          GlobalToast.showErrorToast(
            context,
            message: 'Đã xảy ra lỗi khi xóa thành viên: $next',
          );
        }
      },
    );

    return PopScope(
      canPop: !isKicking,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Xóa thành viên?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có chắc chắn muốn xóa ${widget.member.username} khỏi hành trình này không?',
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hành động này không thể hoàn tác.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isKicking) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Đang xóa thành viên...',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: isKicking ? null : () => context.pop(),
            child: Text(
              'Hủy',
              style: TextStyle(
                color: isKicking
                    ? colorScheme.outline.withValues(alpha: 0.5)
                    : colorScheme.outline,
              ),
            ),
          ),
          FilledButton(
            onPressed: isKicking ? null : _kickMember,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              disabledBackgroundColor: colorScheme.error.withValues(alpha: 0.5),
            ),
            child: isKicking
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onError.withValues(alpha: 0.7),
                    ),
                  )
                : const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
