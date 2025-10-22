import 'package:flutter/material.dart';

import '../../../../../../../../common/validator/validator.dart';

class GroupSizeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const GroupSizeField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Group size',
        hintText: 'e.g. 2 (number of people sharing the trip, max 6)',
        helperText: 'Enter how many people will participate (1-6)',
      ),
      validator: Validator.validateGroupSize,
    );
  }
}
