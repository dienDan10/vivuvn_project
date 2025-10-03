import 'package:flutter/material.dart';

class PasswordInputGlobal extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordInputGlobal({
    super.key,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    this.validator,
  });

  @override
  State<PasswordInputGlobal> createState() => _PasswordInputGlobalState();
}

class _PasswordInputGlobalState extends State<PasswordInputGlobal> {
  bool _isPasswordVisible = false;

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
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}