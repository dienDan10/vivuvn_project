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
            border: InputBorder.none,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.5),
            ),
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.swap_horiz,
                        size: 16,
                        color: Colors.grey,
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
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
