import 'package:flutter/material.dart';

import '../../../login/ui/widgets/btn_submit.dart';
import '../../../login/ui/widgets/password_input_global.dart';
import '../../../login/ui/widgets/text_input_global.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            hintText: 'Username',
            keyboardType: TextInputType.text,
            controller: _usernameController,
          ),

          const SizedBox(height: 24),

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

          // Confirm Password field
          PasswordInputGlobal(
            hintText: 'Confirm Password',
            keyboardType: TextInputType.text,
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 24),

          // Submit button
          ButtonSubmit(text: 'Sign up', onPressed: () {}),
        ],
      ),
    );
  }
}
