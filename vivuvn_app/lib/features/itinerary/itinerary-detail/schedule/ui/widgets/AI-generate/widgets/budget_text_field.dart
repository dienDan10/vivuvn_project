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
  bool _isFormatting = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(automicallyGenerateByAiControllerProvider);
    _controller = TextEditingController(
      text: state.budget > 0 ? _formatBudget(state.budget) : '',
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
      if (!_focusNode.hasFocus) {
        // When focus is lost, format the displayed value to avoid trailing .0
        _formatControllerText();
        FocusScope.of(context).unfocus();
      }
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
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
      validator: (final v) => Validator.validateBudget(v, currency: s.currency),
    );
  }

  String _formatBudget(final double value) {
    // Show as integer if there's no fractional part
    if (value % 1 == 0) return value.toInt().toString();
    // Otherwise, remove any trailing zeros while keeping decimals
    var text = value.toString();
    if (text.contains('.') && text.endsWith('0')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      if (text.endsWith('.')) text = text.substring(0, text.length - 1);
    }
    return text;
  }

  void _formatControllerText() {
    if (_isFormatting) return;
    final raw = _controller.text.replaceAll(',', '').trim();
    final value = double.tryParse(raw);
    if (value == null) return;

    final formatted = _formatBudget(value);
    if (formatted == _controller.text) return;

    _isFormatting = true;
    // Update controller text and move cursor to end
    _controller.text = formatted;
    _controller.selection = TextSelection.collapsed(offset: formatted.length);
    _isFormatting = false;
  }
}
