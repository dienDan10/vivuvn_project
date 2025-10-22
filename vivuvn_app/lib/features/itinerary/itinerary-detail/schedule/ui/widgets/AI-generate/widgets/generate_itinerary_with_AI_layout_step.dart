import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';
import 'budget_field.dart';
import 'group_size_field.dart';
import 'note_field.dart';

class GenerateItineraryWithAiLayout extends ConsumerStatefulWidget {
  final List<String> selectedInterests;
  final GlobalKey<FormState>? formKey;

  const GenerateItineraryWithAiLayout({
    super.key,
    required this.selectedInterests,
    this.formKey,
  });

  @override
  ConsumerState<GenerateItineraryWithAiLayout> createState() =>
      _GenerateItineraryWithAiLayoutState();
}

class _GenerateItineraryWithAiLayoutState
    extends ConsumerState<GenerateItineraryWithAiLayout> {
  // internal key used only if widget.formKey is not provided
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();
  late final TextEditingController _budgetController;
  String _currency = 'VND';
  String? _convertedVnd;
  static const double _usdToVndRate = 24000; // example fixed rate
  late final TextEditingController _groupController;
  late final TextEditingController _noteController;
  final FocusNode _budgetFocus = FocusNode();
  final FocusNode _groupFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    final state = ref.read(automicallyGenerateByAiControllerProvider);
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );
    _budgetController = TextEditingController(
      text: state.budget > 0 ? state.budget.toString() : '',
    );
    _groupController = TextEditingController(text: state.groupSize.toString());
    _noteController = TextEditingController(
      text: state.specialRequirements ?? '',
    );

    // update conversion and controller on changes
    _budgetController.addListener(() {
      _updateConversion();
      final text = _budgetController.text.replaceAll(',', '').trim();
      final value = double.tryParse(text);
      if (value != null) controller.setBudget(value);
    });

    _groupController.addListener(() {
      final n = int.tryParse(_groupController.text);
      if (n != null) controller.setGroupSize(n);
    });

    _noteController.addListener(() {
      controller.setSpecialRequirements(_noteController.text.trim());
    });

    // Hide keyboard when any field loses focus
    _budgetFocus.addListener(() {
      if (!_budgetFocus.hasFocus) FocusScope.of(context).unfocus();
    });
    _groupFocus.addListener(() {
      if (!_groupFocus.hasFocus) FocusScope.of(context).unfocus();
    });
    _noteFocus.addListener(() {
      if (!_noteFocus.hasFocus) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _groupController.dispose();
    _noteController.dispose();
    _budgetFocus.dispose();
    _groupFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _updateConversion() {
    if (_currency != 'USD') {
      setState(() => _convertedVnd = null);
      return;
    }

    final text = _budgetController.text.replaceAll(',', '').trim();
    final value = double.tryParse(text);
    if (value == null) {
      setState(() => _convertedVnd = null);
      return;
    }
    final vnd = (value * _usdToVndRate).round();
    setState(() => _convertedVnd = _formatVnd(vnd));
  }

  String _formatVnd(final int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (final m) => ',');
  }

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget.formKey ?? _internalFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              Text(
                'Generate Your Itinerary With AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Let our AI Agent build an appropriate plan for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),

              BudgetField(
                controller: _budgetController,
                focusNode: _budgetFocus,
                currency: _currency,
                onCurrencyChanged: (final v) => setState(() {
                  _currency = v ?? 'VND';
                  _updateConversion();
                }),
                convertedVnd: _convertedVnd,
              ),

              const SizedBox(height: 16),

              GroupSizeField(
                controller: _groupController,
                focusNode: _groupFocus,
              ),

              const SizedBox(height: 16),

              NoteField(controller: _noteController, focusNode: _noteFocus),

              const SizedBox(height: 20),

              // Selected Interests
              Text(
                'Selected Interests:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.selectedInterests
                    .map((final e) => Chip(label: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
