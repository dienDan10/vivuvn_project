import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../common/toast/global_toast.dart';
import '../../../../controller/automically_generate_by_ai_controller.dart';
import '../../../../controller/validate_and_submit_result.dart';
import 'loading_status_dialog.dart';

class ModalContinueButton extends ConsumerWidget {
  const ModalContinueButton({super.key});

  Future<void> _onPressed(
    final WidgetRef ref,
    final BuildContext context,
  ) async {
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );
    final stateStep = ref.read(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );

    const lastStep = 2;
    if (stateStep == lastStep) {
      // show loading while controller performs submit
      _showLoadingDialog(context);
      final ValidateAndSubmitResult res = await controller.validateAndSubmit();
      // close loading
      if (context.mounted) Navigator.of(context).pop();

      if (res.status == ValidateAndSubmitStatus.submittedSuccess &&
          context.mounted) {
        GlobalToast.showSuccessToast(
          context,
          message: 'Tạo lịch trình thành công',
        );
      } else if (res.status == ValidateAndSubmitStatus.submittedError &&
          context.mounted) {
        GlobalToast.showErrorToast(
          context,
          message: res.message ?? 'Không thể tạo lịch trình',
        );
      } else if (res.status == ValidateAndSubmitStatus.validationError &&
          context.mounted) {
        // unlikely here because controller returns validationError without submitting
        GlobalToast.showErrorToast(
          context,
          message: res.message ?? 'Dữ liệu không hợp lệ',
        );
      }
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    // Not last step: validate (or instruct to advance) via controller
    final ValidateAndSubmitResult res = await controller.validateAndSubmit();
    if (res.status == ValidateAndSubmitStatus.advance) {
      controller.nextStep();
      return;
    }
    if (res.status == ValidateAndSubmitStatus.validationError &&
        context.mounted) {
      GlobalToast.showErrorToast(
        context,
        message: res.message ?? 'Dữ liệu không hợp lệ',
      );
      return;
    }
  }

  Future<void> _showLoadingDialog(final BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) => const LoadingStatusDialog(),
    );
  }

  // result handling is done inline after controller.validateAndSubmit()

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final stateStep = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );
    final continueLabel = stateStep == 2 ? 'Khởi tạo' : 'Tiếp tục';

    return ElevatedButton(
      onPressed: () async => await _onPressed(ref, context),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        continueLabel,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
