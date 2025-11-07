import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../../controller/register_controller.dart';
import 'email_verification_modal_header.dart';
import 'email_verify_code_input.dart';
import 'resend_email_verification_btn.dart';
import 'verify_email_button.dart';

class EmailVerificationModal extends ConsumerStatefulWidget {
  const EmailVerificationModal({super.key});

  @override
  ConsumerState<EmailVerificationModal> createState() =>
      _EmailVerificationModalState();
}

class _EmailVerificationModalState
    extends ConsumerState<EmailVerificationModal> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (final index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (final index) => FocusNode(),
  );
  final TextEditingController _emailController = TextEditingController();
  bool isCodeComplete = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  void _onChanged(final String value, final int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {
      isCodeComplete = _controllers.every(
        (final controller) => controller.text.isNotEmpty,
      );
    });
  }

  String _getVerificationCode() {
    return _controllers.map((final controller) => controller.text).join();
  }

  void _verifyEmail() {
    final code = _getVerificationCode();
    final email = _emailController.text.trim();

    if (code.length < 6 || email.isEmpty) {
      return;
    }

    ref.read(registerControllerProvider.notifier).verifyEmail(code, email);
  }

  void _resendVerificationEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      GlobalToast.showErrorToast(
        context,
        message: 'Vui lòng nhập email để gửi lại mã xác thực.',
      );
      return;
    }

    ref
        .read(registerControllerProvider.notifier)
        .resendVerificationEmail(email, context);
  }

  @override
  Widget build(final BuildContext context) {
    final verifyEmailError = ref.watch(
      registerControllerProvider.select((final s) => s.verifyEmailError),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const EmailVerificationModalHeader(),
          const SizedBox(height: 24),

          // Email Input
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Nhập email của bạn',
              filled: false,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // OTP Input Label
          Text(
            'Nhập mã xác thực',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // OTP Input
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (final index) {
              return EmailVerifyCodeInput(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                onChanged: (final value) => _onChanged(value, index),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Error message
          if (verifyEmailError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                verifyEmailError,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Verify button
          VerifyEmailButton(
            onPressed: isCodeComplete && _emailController.text.trim().isNotEmpty
                ? _verifyEmail
                : null,
          ),
          const SizedBox(height: 16),

          // Resend code
          ResendEmailVerificationButton(onClick: _resendVerificationEmail),

          const SizedBox(height: 16),

          // Add bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
