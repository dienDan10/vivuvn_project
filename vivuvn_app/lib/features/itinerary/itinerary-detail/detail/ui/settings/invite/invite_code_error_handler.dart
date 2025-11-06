import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/itinerary_detail_controller.dart';

class InviteCodeErrorHandler extends ConsumerStatefulWidget {
  final Widget child;

  const InviteCodeErrorHandler({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<InviteCodeErrorHandler> createState() =>
      _InviteCodeErrorHandlerState();
}

class _InviteCodeErrorHandlerState
    extends ConsumerState<InviteCodeErrorHandler> {
  String? _lastShownError;

  @override
  Widget build(final BuildContext context) {
    final inviteCodeError = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCodeError,
      ),
    );

    // Hiển thị error toast nếu có lỗi mới (tránh hiển thị nhiều lần)
    if (inviteCodeError != null && inviteCodeError != _lastShownError) {
      _lastShownError = inviteCodeError;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          GlobalToast.showErrorToast(
            context,
            message: inviteCodeError,
          );
        }
      });
    }

    return widget.child;
  }
}

