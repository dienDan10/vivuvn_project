import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/login_controller.dart';
import 'password_input_global.dart';
import 'text_input_global.dart';

class StepTwo extends ConsumerWidget {
  final GlobalKey<FormState> _step2FormKey;
  final TextEditingController _emailController;
  final TextEditingController _tokenController;
  final TextEditingController _newPasswordController;
  final TextEditingController _confirmPasswordController;
  final VoidCallback _onBack;
  final VoidCallback _submitStep1;
  final VoidCallback _submitStep2;

  const StepTwo({
    super.key,
    required final GlobalKey<FormState> step2FormKey,
    required final TextEditingController emailController,
    required final TextEditingController tokenController,
    required final TextEditingController newPasswordController,
    required final TextEditingController confirmPasswordController,
    required final VoidCallback onBack,
    required final VoidCallback submitStep1,
    required final VoidCallback submitStep2,
  }) : _step2FormKey = step2FormKey,
       _emailController = emailController,
       _tokenController = tokenController,
       _newPasswordController = newPasswordController,
       _confirmPasswordController = confirmPasswordController,
       _onBack = onBack,
       _submitStep1 = submitStep1,
       _submitStep2 = submitStep2;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isSending = ref.watch(
      loginControllerProvider.select((final s) => s.sendingResetPassword),
    );
    final isResending = ref.watch(
      loginControllerProvider.select((final s) => s.sendingForgotPassword),
    );

    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Description
          Text(
            'Nhập mã xác thực đã được gửi đến email ${_emailController.text} và tạo mật khẩu mới.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Token input
          TextInputGlobal(
            hintText: 'Mã xác thực',
            keyboardType: TextInputType.text,
            controller: _tokenController,
            validator: (final value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập mã xác thực';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // New password input
          PasswordInputGlobal(
            hintText: 'Mật khẩu mới',
            keyboardType: TextInputType.text,
            controller: _newPasswordController,
            validator: (final value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mật khẩu không được để trống';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm password input
          PasswordInputGlobal(
            hintText: 'Xác nhận mật khẩu mới',
            keyboardType: TextInputType.text,
            controller: _confirmPasswordController,
            validator: (final value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (value != _newPasswordController.text) {
                return 'Mật khẩu xác nhận không khớp';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSending ? null : _onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Quay lại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isSending ? null : _submitStep2,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Đặt lại mật khẩu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),

          // Resend code option
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: (isSending || isResending) ? null : _submitStep1,
              child: isResending
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Gửi lại mã xác thực',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
