import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
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
          ),

          const SizedBox(height: 24),

          // Password field
          PasswordInputGlobal(
            hintText: 'Password',
            keyboardType: TextInputType.text,
            controller: _passwordController,
          ),
          const SizedBox(height: 24),

          // Submit button
          ButtonSubmit(text: 'Sign In', onPressed: _submitForm),
        ],
      ),
    );
  }
}
