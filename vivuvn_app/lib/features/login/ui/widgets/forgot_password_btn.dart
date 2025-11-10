import 'package:flutter/material.dart';

import 'forgot_password_dialog.dart';

class ForgotPasswordBtn extends StatelessWidget {
  const ForgotPasswordBtn({super.key});

  void _showForgotPasswordDialog(final BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final context) => const ForgotPasswordDialog(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(top: 16, right: 10),
      child: InkWell(
        onTap: () => _showForgotPasswordDialog(context),
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontStyle: FontStyle.italic,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
