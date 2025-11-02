import 'package:flutter/material.dart';

class ResendEmailVerificationButton extends StatelessWidget {
  const ResendEmailVerificationButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Didn\'t receive the code? Resend',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
        ),
      ),
    );
  }
}
