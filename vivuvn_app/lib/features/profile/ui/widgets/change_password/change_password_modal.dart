import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/toast/global_toast.dart';
import '../../../controller/change_password_controller.dart';
import 'change_password_form.dart';
import 'change_password_header.dart';

class ChangePasswordModal extends ConsumerStatefulWidget {
  const ChangePasswordModal({super.key});

  static Future<void> show(final BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (final context) => const ChangePasswordModal(),
    );
  }

  @override
  ConsumerState<ChangePasswordModal> createState() =>
      _ChangePasswordModalState();
}

class _ChangePasswordModalState extends ConsumerState<ChangePasswordModal> {
  Future<void> _handleSave() async {
    final controller = ref.read(changePasswordControllerProvider.notifier);
    final isLoading = ref.read(
      changePasswordControllerProvider.select((final state) => state.isLoading),
    );

    if (isLoading) return;

    try {
      final message = await controller.changePassword();

      if (mounted) {
        GlobalToast.showSuccessToast(context, message: message);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        GlobalToast.showErrorToast(context, message: e.toString());
      }
    }
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      onPopInvoked: (final didPop) {
        if (didPop) {
          // Reset state when modal is closed
          try {
            ref.read(changePasswordControllerProvider.notifier).reset();
          } catch (e) {
            // Widget was disposed, ignore
          }
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              ChangePasswordHeader(
                onClose: _handleClose,
                onSave: _handleSave,
              ),
              // Form
              const ChangePasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

