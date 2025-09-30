import 'package:flutter/material.dart';

import 'btn_submit.dart';
import 'password_input_global.dart';
import 'text_input_global.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
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
          ButtonSubmit(text: 'Sign In', onPressed: () {}),
        ],
      ),
    );
  }
}
