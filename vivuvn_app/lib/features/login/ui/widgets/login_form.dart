import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/validator/validator.dart';
import '../../../../l10n/app_localizations.dart';
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
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(loginControllerProvider.notifier)
        .updateLoginData(_emailController.text, _passwordController.text);
    await ref.read(loginControllerProvider.notifier).login();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInputGlobal(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (final value) => Validator.validateEmail(value),
          ),
          const SizedBox(height: 24),
          PasswordInputGlobal(
            hintText: AppLocalizations.of(context)!.loginPassword,
            keyboardType: TextInputType.text,
            controller: _passwordController,
            validator: (final value) => Validator.validatePassword(value),
          ),
          const SizedBox(height: 24),
          ButtonSubmit(text: AppLocalizations.of(context)!.loginSubmit, onPressed: _submitForm),
        ],
      ),
    );
  }
}
