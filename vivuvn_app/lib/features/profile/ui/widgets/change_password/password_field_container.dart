import 'package:flutter/material.dart';

class PasswordFieldContainer extends StatelessWidget {
  final Widget child;
  final bool hasError;

  const PasswordFieldContainer({
    super.key,
    required this.child,
    this.hasError = false,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasError
              ? Colors.red
              : (isDark ? const Color(0xFF3C3C3C) : Colors.grey[200]!),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

