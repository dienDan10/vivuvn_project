import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResendEmailVerificationButton extends StatelessWidget {
  final VoidCallback onClick;
  const ResendEmailVerificationButton({super.key, required this.onClick});

  @override
  Widget build(final BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        children: [
          const TextSpan(text: 'Không nhận được mã? '),
          TextSpan(
            text: 'Gửi lại',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onClick,
          ),
        ],
      ),
    );
  }
}
