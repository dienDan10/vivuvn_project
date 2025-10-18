import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/register_controller.dart';
import 'email_verification_modal_header.dart';
import 'email_verify_code_input.dart';
import 'resend_email_verification_btn.dart';
import 'verify_email_button.dart';

class EmailVerificationModal extends ConsumerStatefulWidget {
  final String email;

  const EmailVerificationModal({super.key, required this.email});

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

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(final String value, final int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getVerificationCode() {
    return _controllers.map((final controller) => controller.text).join();
  }

  void _verifyEmail() {
    final code = _getVerificationCode();
    if (code.length < 6) {
      return;
    }

    ref.read(registerControllerProvider.notifier).verifyEmail(code);
  }

  @override
  Widget build(final BuildContext context) {
    final registerState = ref.watch(registerControllerProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          EmailVerificationModalHeader(email: widget.email),
          const SizedBox(height: 32),

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
          if (registerState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                registerState.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Verify button
          VerifyEmailButton(onPressed: _verifyEmail),
          const SizedBox(height: 16),

          // Resend code
          const ResendEmailVerificationButton(),

          // Add bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
