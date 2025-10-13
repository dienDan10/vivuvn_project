import 'package:flutter/material.dart';

import 'budget_field.dart';
import 'group_size_field.dart';
import 'note_field.dart';

class GenerateItineraryWithAiLayout extends StatefulWidget {
  final List<String> selectedInterests;
  final GlobalKey<FormState>? formKey;

  const GenerateItineraryWithAiLayout({
    super.key,
    required this.selectedInterests,
    this.formKey,
  });

  @override
  State<GenerateItineraryWithAiLayout> createState() =>
      _GenerateItineraryWithAiLayoutState();
}

class _GenerateItineraryWithAiLayoutState
    extends State<GenerateItineraryWithAiLayout> {
  // internal key used only if widget.formKey is not provided
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();
  final TextEditingController _budgetController = TextEditingController();
  String _currency = 'VND';
  String? _convertedVnd;
  static const double _usdToVndRate = 24000; // example fixed rate
  final TextEditingController _groupController = TextEditingController(
    text: '1',
  );
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _budgetFocus = FocusNode();
  final FocusNode _groupFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

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

  @override
  void initState() {
    super.initState();
    _budgetController.addListener(_updateConversion);
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
