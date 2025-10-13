import 'package:flutter/material.dart';
import 'widgets/widget/budget_form.dart';

Future<double?> showBudgetDialog(
  final BuildContext context,
  final double currentBudget,
) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (final context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BudgetForm(initialBudget: currentBudget),
      );
    },
  );
}
