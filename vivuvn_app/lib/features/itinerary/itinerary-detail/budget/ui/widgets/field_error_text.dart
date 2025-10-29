import 'package:flutter/material.dart';

/// Widget hiển thị error message cho form fields
class FieldErrorText extends StatelessWidget {
  final String? errorMessage;

  const FieldErrorText({super.key, this.errorMessage});

  @override
  Widget build(final BuildContext context) {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        errorMessage!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
