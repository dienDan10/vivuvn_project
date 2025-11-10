import 'package:flutter/material.dart';

class PasswordFieldIcon extends StatelessWidget {
  const PasswordFieldIcon({super.key});

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.lock_outline,
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }
}

