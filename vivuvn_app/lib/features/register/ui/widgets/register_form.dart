import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/validator/validator.dart';
import '../../../login/ui/widgets/btn_submit.dart';
import '../../../login/ui/widgets/password_input_global.dart';
import '../../../login/ui/widgets/text_input_global.dart';
import '../../controller/register_controller.dart';

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
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    ref
        .read(registerControllerProvider.notifier)
        .updateRegisterData(
          _emailController.text,
          _usernameController.text,
          _passwordController.text,
        );

    final isSuccess = await ref
        .read(registerControllerProvider.notifier)
        .register();

    if (isSuccess) {
      CherryToast.success(
        title: const Text('Register Successful'),
        toastPosition: Position.top,
      ).show(context);

      // TODO: chuyển sang login sau khi đăng ký thành công
      // context.go('/login');
    } else {
      final error = ref.read(registerControllerProvider).error;
      CherryToast.error(
        title: const Text('Register Failed'),
        description: Text(error ?? 'Unknown error'),
        toastPosition: Position.top,
      ).show(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
    // 🔹 Lắng nghe error trong build
    ref.listen<String?>(
      registerControllerProvider.select((final s) => s.error),
      (final previous, final next) {
        if (next != null && next.isNotEmpty) {
          CherryToast.error(
            title: const Text('Register Failed'),
            description: Text(next),
            toastPosition: Position.top,
          ).show(context);
        }
      },
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username
          TextInputGlobal(
            hintText: 'Username',
            keyboardType: TextInputType.text,
            controller: _usernameController,
            validator: (final value) =>
                value == null || value.isEmpty ? 'Enter username' : null,
          ),
          const SizedBox(height: 24),

          // Email
          TextInputGlobal(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (final value) => Validator.validateEmail(value),
          ),
          const SizedBox(height: 24),

          // Password
          PasswordInputGlobal(
            hintText: 'Password',
            keyboardType: TextInputType.text,
            controller: _passwordController,
            validator: (final value) => Validator.validatePassword(value),
          ),
          const SizedBox(height: 24),

          // Confirm Password
          PasswordInputGlobal(
            hintText: 'Confirm Password',
            keyboardType: TextInputType.text,
            controller: _confirmPasswordController,
            validator: (final value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Submit button
          ButtonSubmit(text: 'Sign Up', onPressed: _submitForm),
        ],
      ),
    );
  }
}
