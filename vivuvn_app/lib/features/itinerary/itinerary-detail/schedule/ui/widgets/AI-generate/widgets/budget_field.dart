import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';
import 'budget_text_field.dart';
import 'conversion_info.dart';
import 'currency_dropdown.dart';

class BudgetField extends ConsumerStatefulWidget {
  const BudgetField({super.key});

  @override
  ConsumerState<BudgetField> createState() => _BudgetFieldState();
}

class _BudgetFieldState extends ConsumerState<BudgetField> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(child: BudgetTextField()),
            SizedBox(width: 12),
            CurrencyDropdown(),
          ],
        ),
        if (s.currency == 'USD') const ConversionInfo(),
      ],
    );
  }
}
