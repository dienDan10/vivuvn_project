import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../../controller/register_controller.dart';
import 'btn_submit_register.dart';
import 'confirm_password_input.dart';
import 'email_input.dart';
import 'password_input.dart';
import 'username_input.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    ref
        .read(registerControllerProvider.notifier)
        .updateRegisterData(
          _emailController.text,
          _usernameController.text,
          _passwordController.text,
        );
    await ref.read(registerControllerProvider.notifier).register();
  }

  void _errorListener() {
    ref.listen(
      registerControllerProvider.select((final state) => state.error),
      (final previous, final next) {
        if (next != null && next.isNotEmpty) {
          // show toast error message
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    _errorListener();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          UsernameInput(controller: _usernameController),
          const SizedBox(height: 24),
          EmailInput(controller: _emailController),
          const SizedBox(height: 24),
          PasswordInput(controller: _passwordController),
          const SizedBox(height: 24),
          ConfirmPasswordInput(
            controller: _confirmPasswordController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 24),
          ButtonSubmitRegister(text: 'Sign Up', onPressed: _submitForm),
        ],
      ),
    );
  }
}
