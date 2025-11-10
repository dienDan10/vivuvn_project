import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editable_field_edit_mode.dart';
import 'editable_field_view_mode.dart';
import 'field_container_widget.dart';

class EditableFieldWidget extends ConsumerWidget {
  final String label;
  final String value;
  final TextEditingController controller;
  final IconData icon;
  final bool isEditing;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final TextInputType? keyboardType;

  const EditableFieldWidget({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    required this.icon,
    required this.isEditing,
    required this.onTap,
    required this.onCancel,
    required this.onSave,
    this.keyboardType,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return FieldContainerWidget(
      child: isEditing
          ? EditableFieldEditMode(
              label: label,
              controller: controller,
              icon: icon,
              keyboardType: keyboardType,
              onCancel: onCancel,
              onSave: onSave,
            )
          : EditableFieldViewMode(
              label: label,
              value: value,
              icon: icon,
              onTap: onTap,
            ),
    );
  }
}

