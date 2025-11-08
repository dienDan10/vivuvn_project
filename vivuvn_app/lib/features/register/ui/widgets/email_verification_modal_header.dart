import 'package:flutter/material.dart';

class EmailVerificationModalHeader extends StatelessWidget {
  const EmailVerificationModalHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),

        // Icon
        Icon(
          Icons.verified_user_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          'Xác thực Email',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          'Nhập mã xác thực đã được gửi đến email của bạn.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
