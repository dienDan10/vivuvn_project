import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// validator moved to controller-level; no import needed here
import '../../../../controller/automically_generate_by_ai_controller.dart';

class BudgetTextField extends ConsumerStatefulWidget {
  const BudgetTextField({super.key});

  @override
  ConsumerState<BudgetTextField> createState() => _BudgetTextFieldState();
}

class _BudgetTextFieldState extends ConsumerState<BudgetTextField> {
  late final TextEditingController _controller;
  final bool _isFormatting = false;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final stateBudget = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.budget),
    );
    final ctrl = ref.read(automicallyGenerateByAiControllerProvider.notifier);
    _controller = TextEditingController(
      text: stateBudget > 0 ? ctrl.formatBudget(stateBudget) : '',
    );

    _controller.addListener(() {
      if (_isFormatting) return;
      // Delegate parsing/validation to the controller so widgets remain presentation-only
      ref
          .read(automicallyGenerateByAiControllerProvider.notifier)
          .setBudgetFromString(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Keep widget presentation-only; controller handles validation/state
    return TextField(
      controller: _controller,
      onTapOutside: (final event) => FocusScope.of(context).unfocus(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Nhập ngân sách...',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
      // Validation handled at controller/modal level; keep field presentation-only
    );
  }
}
