import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/validator/validator.dart';
import '../../../../core/routes/routes.dart';
import '../../../login/ui/widgets/password_input_global.dart';
import '../../../login/ui/widgets/text_input_global.dart';
import '../../controller/register_controller.dart';
import '../../state/register_state.dart';
import 'btn_submit_register.dart';

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

    // Cập nhật data trước validate
    ref
        .read(registerControllerProvider.notifier)
        .updateRegisterData(
          _emailController.text,
          _usernameController.text,
          _passwordController.text,
        );

    // Validate lần đầu
    if (!_formKey.currentState!.validate()) return;

    // Gọi register
    final isSuccess = await ref
        .read(registerControllerProvider.notifier)
        .register();

    // Force rebuild form để validator đọc emailError mới
    setState(() {
      _formKey.currentState!.validate();
    });

    final state = ref.read(registerControllerProvider);

    if (isSuccess) {
      CherryToast.success(
        title: const Text('Register Successful'),
        toastPosition: Position.top,
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) context.go(loginRoute);
      });
    } else {
      if (state.error != null &&
          !state.error!.contains('Email is already in use')) {
        CherryToast.error(
          title: const Text('Register Failed'),
          description: Text(state.error!),
          toastPosition: Position.top,
        ).show(context);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(registerControllerProvider);

    // Lắng nghe emailError để rebuild form ngay lập tức
    ref.listen<RegisterState>(registerControllerProvider, (
      final prev,
      final next,
    ) {
      if (prev?.emailError != next.emailError) {
        _formKey.currentState?.validate();
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInputGlobal(
            hintText: 'Username',
            keyboardType: TextInputType.text,
            controller: _usernameController,
            validator: (final value) =>
                value == null || value.isEmpty ? 'Enter username' : null,
          ),
          const SizedBox(height: 24),
          TextInputGlobal(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (final value) {
              final emailValidation = Validator.validateEmail(value);
              if (emailValidation != null) return emailValidation;
              // Watch state trực tiếp để validator luôn cập nhật
              final emailError = ref
                  .watch(registerControllerProvider)
                  .emailError;
              return emailError;
            },
            onChanged: (_) {
              ref.read(registerControllerProvider.notifier).clearEmailError();
            },
          ),
          const SizedBox(height: 24),
          PasswordInputGlobal(
            hintText: 'Password',
            keyboardType: TextInputType.text,
            controller: _passwordController,
            validator: Validator.validatePassword,
          ),
          const SizedBox(height: 24),
          PasswordInputGlobal(
            hintText: 'Confirm Password',
            keyboardType: TextInputType.text,
            controller: _confirmPasswordController,
            validator: (final value) {
              if (value == null || value.isEmpty)
                return 'Please confirm your password';
              if (value != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 24),
          ButtonSubmitRegister(text: 'Sign Up', onPressed: _submitForm),
        ],
      ),
    );
  }
}
