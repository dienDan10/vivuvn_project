import 'package:flutter/material.dart';

class FieldDetails extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const FieldDetails({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      onTapOutside: (final event) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      enabled: enabled,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Ghi chú',
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}
