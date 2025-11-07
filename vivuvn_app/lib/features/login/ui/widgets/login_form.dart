import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../../../../common/validator/validator.dart';
import '../../controller/login_controller.dart';
import 'btn_submit.dart';
import 'password_input_global.dart';
import 'text_input_global.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // remove keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref
        .read(loginControllerProvider.notifier)
        .updateLoginData(_emailController.text, _passwordController.text);

    await ref.read(loginControllerProvider.notifier).login();
  }

  // Handle Error State
  void _listener() {
    ref.listen(loginControllerProvider.select((final state) => state.error), (
      final previous,
      final next,
    ) {
      if (next != null && next.isNotEmpty) {
        // show toast error message
        GlobalToast.showErrorToast(context, message: next);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    _listener();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextInputGlobal(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (final value) => Validator.validateEmail(value),
          ),

          const SizedBox(height: 24),

          // Password field
          PasswordInputGlobal(
            hintText: 'Mật khẩu',
            keyboardType: TextInputType.text,
            controller: _passwordController,
            validator: (final value) => Validator.validatePassword(value),
          ),
          const SizedBox(height: 24),

          // Submit button
          ButtonSubmit(text: 'Đăng nhập', onPressed: _submitForm),
        ],
      ),
    );
  }
}
