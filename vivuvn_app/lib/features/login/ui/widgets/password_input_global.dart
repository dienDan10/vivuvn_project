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
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            //spreadRadius: 2,
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
                // Toggle password visibility
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: _isPasswordVisible
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
