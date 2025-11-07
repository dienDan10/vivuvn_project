import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/validator/validator.dart';
import '../../controller/login_controller.dart';
import 'text_input_global.dart';

class StepOne extends ConsumerWidget {
  final GlobalKey<FormState> _step1FormKey;
  final TextEditingController _emailController;
  final VoidCallback _submitStep1;

  const StepOne({
    super.key,
    required final GlobalKey<FormState> step1FormKey,
    required final TextEditingController emailController,
    required final VoidCallback submitStep1,
  }) : _step1FormKey = step1FormKey,
       _emailController = emailController,
       _submitStep1 = submitStep1;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isSending = ref.watch(
      loginControllerProvider.select((final s) => s.sendingForgotPassword),
    );

    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Description
          Text(
            'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi mã xác thực để đặt lại mật khẩu.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Email input
          TextInputGlobal(
            hintText: 'Nhập email của bạn',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: Validator.validateEmail,
          ),
          const SizedBox(height: 24),

          // Submit button
          ElevatedButton(
            onPressed: isSending ? null : _submitStep1,
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
                    'Gửi mã xác thực',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
