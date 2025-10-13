import 'package:flutter/material.dart';

import 'expense_form.dart';

Future<Map<String, dynamic>?> showAddExpenseDialog(final BuildContext context) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (final context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const AddExpenseForm(),
    ),
  );
}
