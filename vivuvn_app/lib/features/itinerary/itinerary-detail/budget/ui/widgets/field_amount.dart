import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/helper/number_format_helper.dart';
import '../../../../../../common/validator/validator.dart';
import '../../utils/budget_constants.dart';

class FieldAmount extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool isUSD) onCurrencyChanged;

  const FieldAmount({
    super.key,
    required this.controller,
    required this.onCurrencyChanged,
  });

  @override
  State<FieldAmount> createState() => _FieldAmountState();
}

class _FieldAmountState extends State<FieldAmount> {
  bool isUSD = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // Update UI when amount changes
    });
  }

  String _formatNumber(final double number) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(number.round());
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(
      widget.controller.text.replaceAll(',', '').trim(),
    );
    final showConversion = amount != null && amount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTapOutside: (final event) {
            FocusScope.of(context).unfocus();
          },
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.attach_money),
            labelText: 'Số tiền',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
                width: 0.8,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () {
                  // Dismiss keyboard before changing currency
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isUSD = !isUSD;
                  });
                  widget.onCurrencyChanged(isUSD); // Use new value after toggle
                },
            borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUSD ? 'USD' : 'VNĐ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.swap_horiz,
                        size: 16,
                        color: theme.iconTheme.color ??
                            theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          validator: (final value) =>
              Validator.money(value, fieldName: 'amount'),
        ),
        if (showConversion)
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 4),
            child: Row(
              children: [
                Text(
                  'Tỷ giá: 1 USD = ${_formatNumber(BudgetConstants.exchangeRate)} đ',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(
                    color:
                        theme.colorScheme.outline.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isUSD
                      ? '≈ ${_formatNumber(amount * BudgetConstants.exchangeRate)} đ'
                      : '≈ \$${(amount / BudgetConstants.exchangeRate).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
