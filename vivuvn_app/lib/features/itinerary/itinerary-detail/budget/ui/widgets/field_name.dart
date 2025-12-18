import 'package:flutter/material.dart';

import '../../../../../../common/validator/validator.dart';

class FieldName extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const FieldName({super.key, required this.controller, this.enabled = true});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onTapOutside: (final event) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      enabled: enabled,
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.shopping_cart_outlined),
        labelText: 'Tên chi phí',
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
      validator: (final value) {
        // Check empty
        final emptyError = Validator.notEmpty(value, fieldName: 'Tên chi phí');
        if (emptyError != null) return emptyError;

        // Check prohibited words
        if (Validator.containsSensitiveWords(value)) {
          return 'Tên chứa từ ngữ không được phép';
        }

        return null;
      },
    );
  }
}
