import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/toast/global_toast.dart';
import '../../controller/itinerary_controller.dart';

class DeleteConfirmDialog extends ConsumerStatefulWidget {
  final int itineraryId;
  const DeleteConfirmDialog({super.key, required this.itineraryId});

  @override
  ConsumerState<DeleteConfirmDialog> createState() =>
      _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends ConsumerState<DeleteConfirmDialog> {
  void _deleteItinerary() async {
    // Call the delete method from the controller
    await ref
        .read(itineraryControllerProvider.notifier)
        .deleteItinerary(widget.itineraryId);
    if (mounted) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Xóa chuyến đi thành công',
      );
      context.pop(); // Close the dialog
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
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 48,
        ),
        title: Text(isLoading ? 'Đang xóa...' : 'Xóa chuyến đi?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CircularProgressIndicator(color: colorScheme.error),
              ),
            Text(
              isLoading
                  ? 'Vui lòng đợi trong khi chúng tôi xóa chuyến đi của bạn.'
                  : 'Bạn có chắc chắn muốn xóa chuyến đi này? Hành động này không thể hoàn tác.',
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
            onPressed: isLoading ? null : _deleteItinerary,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onError,
                    ),
                  )
                : const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
