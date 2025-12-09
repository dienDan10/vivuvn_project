import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/toast/global_toast.dart';
import '../../../../home/controller/home_controller.dart';
import '../../controller/itinerary_controller.dart';

class LeaveConfirmDialog extends ConsumerStatefulWidget {
  final int itineraryId;
  final bool popToList;
  const LeaveConfirmDialog({super.key, required this.itineraryId, this.popToList = false});

  @override
  ConsumerState<LeaveConfirmDialog> createState() => _LeaveConfirmDialogState();
}

class _LeaveConfirmDialogState extends ConsumerState<LeaveConfirmDialog> {
  Future<void> _leaveItinerary() async {
    await ref
        .read(itineraryControllerProvider.notifier)
        .leaveItinerary(widget.itineraryId);
    // Refresh home public itineraries so isMember/isOwner flags update
    await ref.read(homeControllerProvider.notifier).refreshHomeData();
    if (mounted) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Đã rời khỏi chuyến đi',
      );
      final navigator = Navigator.of(context);
      navigator.pop(); // close dialog
      if (widget.popToList && navigator.canPop()) {
        navigator.pop(); // leave detail to list
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(itineraryControllerProvider).isLoading;

    ref.listen(
      itineraryControllerProvider.select((final state) => state.error),
      (final prev, final next) {
        if (next != null && mounted) {
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );

    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        icon: Icon(
          Icons.logout,
          color: colorScheme.primary,
          size: 48,
        ),
        title: Text(isLoading ? 'Đang xử lý...' : 'Rời khỏi chuyến đi?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
            Text(
              isLoading
                  ? 'Vui lòng đợi trong khi chúng tôi xử lý yêu cầu.'
                  : 'Bạn có chắc chắn muốn rời khỏi chuyến đi này?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isLoading
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: isLoading ? null : () => context.pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: isLoading ? null : _leaveItinerary,
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Text('Rời khỏi'),
          ),
        ],
      ),
    );
  }
}


