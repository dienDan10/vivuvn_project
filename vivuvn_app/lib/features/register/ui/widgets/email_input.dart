import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/validator/validator.dart';
import '../../../login/ui/widgets/text_input_global.dart';

class EmailInput extends ConsumerWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return TextInputGlobal(
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      validator: Validator.validateEmail,
    );
  }
}
