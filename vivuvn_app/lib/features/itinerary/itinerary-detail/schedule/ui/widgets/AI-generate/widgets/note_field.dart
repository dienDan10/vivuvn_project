import 'package:flutter/material.dart';

import '../../../../../../../../common/validator/validator.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const NoteField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Note',
        hintText:
            'e.g. Prefer quieter hotels, vegetarian meals, avoid steep hikes',
        helperText: 'Optional: any special requests or constraints',
      ),
      validator: Validator.validateNote,
    );
  }
}
