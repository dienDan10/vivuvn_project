import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSubmit({super.key, required this.text, required this.onPressed});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onPressed,

      // Handle button tap
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
