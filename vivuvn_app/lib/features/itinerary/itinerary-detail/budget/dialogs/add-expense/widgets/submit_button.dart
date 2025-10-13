import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
