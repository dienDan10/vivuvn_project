import 'package:flutter/material.dart';

import '../../../../../../common/validator/validator.dart';

class BudgetField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;
  final String? convertedVnd;

  const BudgetField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.currency,
    required this.onCurrencyChanged,
    this.convertedVnd,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  hintText: 'e.g. 200 for USD or 4,800,000 for VND',
                  helperText:
                      'Enter total budget for the trip (total for all people)',
                ),
                validator: (final v) =>
                    Validator.validateBudget(v, currency: currency),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: currency,
              items: const [
                DropdownMenuItem(value: 'VND', child: Text('VND')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
              ],
              onChanged: onCurrencyChanged,
            ),
          ],
        ),
        if (currency == 'USD')
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1 USD ≈ 24,000 VND (approx)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                if (convertedVnd != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '≈ $convertedVnd VND',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
