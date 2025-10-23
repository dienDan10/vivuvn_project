import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../common/toast/global_toast.dart';
import '../../../../controller/automically_generate_by_ai_controller.dart';
import 'interest_footer.dart';

class ModalFooterWidget extends ConsumerWidget {
  const ModalFooterWidget({
    super.key,
    required this.canProceed,
    required this.formKey,
  });

  final bool canProceed;
  final GlobalKey<FormState> formKey;

  void _showValidationError(final BuildContext context) {
    CherryToast.error(
      title: const Text('Xác thực thất bại'),
      description: const Text('Vui lòng sửa các trường được đánh dấu.'),
      displayCloseButton: false,
      toastPosition: Position.top,
    ).show(context);
  }

  Future<void> _showProgressDialog(final BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Đang tạo lịch trình...'),
          ],
        ),
      ),
    );
  }

  void _handleResult(final BuildContext context, final WidgetRef ref) {
    final newState = ref.read(automicallyGenerateByAiControllerProvider);
    if (newState.isGenerated == true) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Tạo lịch trình thành công',
      );
      if (context.mounted) Navigator.of(context).maybePop();
      return;
    }

    GlobalToast.showErrorToast(
      context,
      message: newState.error ?? 'Máy chủ không trả về dữ liệu sinh ra.',
    );
  }

  Future<void> _onNext(final BuildContext context, final WidgetRef ref) async {
    final step = ref.read(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );

    if (step == 1) {
      controller.nextStep();
      return;
    }

    // Validate form fields before generating
    final form = formKey.currentState;
    if (form == null || !form.validate()) {
      _showValidationError(context);
      return;
    }

    // Show progress while controller performs the generation
    _showProgressDialog(context);
    try {
      await controller.submitGenerate();
    } finally {
      // Always close the progress dialog if still mounted
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    }

    // Handle result toast and optional modal close
    _handleResult(context, ref);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final step = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );
    final isLoading = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final s) => s.isLoading,
      ),
    );

    return InterestFooter(
      canProceed: canProceed,
      onCancel: () => Navigator.of(context).maybePop(),
      primaryLabel: step == 2 ? 'Tạo' : 'Tiếp',
      isLoading: isLoading,
      onNext: () => _onNext(context, ref),
    );
  }
}
