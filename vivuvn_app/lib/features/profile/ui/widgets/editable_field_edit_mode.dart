import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field_action_buttons.dart';

class EditableFieldEditMode extends ConsumerWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const EditableFieldEditMode({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.onCancel,
    required this.onSave,
    this.keyboardType,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              autofocus: true,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                isDense: true,
                labelText: label,
                labelStyle: TextStyle(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.6,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FieldActionButtons(onCancel: onCancel, onSave: onSave),
        ],
      ),
    );
  }
}
