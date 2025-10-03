import 'package:flutter/material.dart';

class TextInputGlobal extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TextInputGlobal({
    super.key,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.12),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(0),
        ),
        validator: validator,
      ),
    );
  }
}