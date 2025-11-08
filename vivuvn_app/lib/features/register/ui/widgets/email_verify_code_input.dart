import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerifyCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  const EmailVerifyCodeInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          filled: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (final value) => onChanged(value),
      ),
    );
  }
}
