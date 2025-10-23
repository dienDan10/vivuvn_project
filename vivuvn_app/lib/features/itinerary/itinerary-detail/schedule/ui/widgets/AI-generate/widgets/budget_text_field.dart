import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../common/validator/validator.dart';
import '../../../../controller/automically_generate_by_ai_controller.dart';

class BudgetTextField extends ConsumerStatefulWidget {
  const BudgetTextField({super.key});

  @override
  ConsumerState<BudgetTextField> createState() => _BudgetTextFieldState();
}

class _BudgetTextFieldState extends ConsumerState<BudgetTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final state = ref.read(automicallyGenerateByAiControllerProvider);
    _controller = TextEditingController(
      text: state.budget > 0 ? state.budget.toString() : '',
    );
    _focusNode = FocusNode();

    _controller.addListener(() {
      final text = _controller.text.replaceAll(',', '').trim();
      final value = double.tryParse(text);
      if (value != null) {
        ref
            .read(automicallyGenerateByAiControllerProvider.notifier)
            .setBudget(value);
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final s = ref.watch(automicallyGenerateByAiControllerProvider);

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Nhập ngân sách...',
        helperText: 'Tổng ngân sách cho chuyến đi',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
      validator: (final v) => Validator.validateBudget(v, currency: s.currency),
    );
  }
}
