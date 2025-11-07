import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/toast/global_toast.dart';
import '../../controller/login_controller.dart';
import 'step_circle.dart';
import 'step_one.dart';
import 'step_two.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  // Step tracking
  int _currentStep = 1;

  // Controllers for step 1
  final TextEditingController _emailController = TextEditingController();

  // Controllers for step 2
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Form keys
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitStep1() async {
    if (!_step1FormKey.currentState!.validate()) return;

    await ref
        .read(loginControllerProvider.notifier)
        .forgotPassword(_emailController.text);

    if (!mounted) return;

    final state = ref.read(loginControllerProvider);

    if (state.forgotPasswordError != null) {
      GlobalToast.showErrorToast(context, message: state.forgotPasswordError!);
      return;
    }

    if (state.sendForgotPasswordSuccess) {
      setState(() {
        _currentStep = 2;
      });
      GlobalToast.showSuccessToast(
        context,
        message: 'Mã xác thực đã được gửi đến email của bạn',
      );
    }
  }

  Future<void> _submitStep2() async {
    if (!_step2FormKey.currentState!.validate()) return;

    await ref
        .read(loginControllerProvider.notifier)
        .resetPassword(
          _emailController.text,
          _newPasswordController.text,
          _tokenController.text,
        );

    if (!mounted) return;

    final state = ref.read(loginControllerProvider);

    if (state.resetPasswordError != null) {
      GlobalToast.showErrorToast(context, message: state.resetPasswordError!);
      return;
    }

    // Success - close dialog and show success message
    context.pop();
    GlobalToast.showSuccessToast(
      context,
      message: 'Mật khẩu đã được thay đổi thành công!',
    );
  }

  void _onBack() {
    setState(() {
      _currentStep = 1;
      _tokenController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.lock_reset,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Quên mật khẩu',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                    tooltip: 'Đóng',
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Step indicator
              _buildStepIndicator(),
              const SizedBox(height: 24),

              // Content based on current step
              if (_currentStep == 1)
                StepOne(
                  step1FormKey: _step1FormKey,
                  emailController: _emailController,
                  submitStep1: _submitStep1,
                )
              else
                StepTwo(
                  step2FormKey: _step2FormKey,
                  emailController: _emailController,
                  tokenController: _tokenController,
                  newPasswordController: _newPasswordController,
                  confirmPasswordController: _confirmPasswordController,
                  onBack: _onBack,
                  submitStep1: _submitStep1,
                  submitStep2: _submitStep2,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepCircle(1, 'Gửi email'),
        Expanded(
          child: Container(
            height: 2,
            color: _currentStep >= 2
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
          ),
        ),
        _buildStepCircle(2, 'Đặt lại mật khẩu'),
      ],
    );
  }

  Widget _buildStepCircle(final int step, final String label) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;

    return StepCircle(
      step: step,
      label: label,
      isActive: isActive,
      isCompleted: isCompleted,
    );
  }
}
