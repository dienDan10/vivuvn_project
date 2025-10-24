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
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final stateBudget = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.budget),
    );
    _controller = TextEditingController(
      text: stateBudget > 0 ? stateBudget.toString() : '',
    );

    _controller.addListener(() {
      final text = _controller.text.replaceAll(',', '').trim();
      final value = double.tryParse(text);
      if (value != null) {
        ref
            .read(automicallyGenerateByAiControllerProvider.notifier)
            .setBudget(value);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final stateCurrency = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.currency),
    );

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
        if (stateCurrency == 'USD') const ConversionInfo(),
      ],
    );
  }
}
