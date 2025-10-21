import 'package:flutter/material.dart';

import 'add_expense_layout.dart';

class ButtonAddBudgetItem extends StatelessWidget {
  const ButtonAddBudgetItem({super.key});

  void _openAddExpenseDialog(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      useSafeArea: false,
      constraints: const BoxConstraints.expand(),
      backgroundColor: Colors.transparent,
      builder: (final context) => const AddExpenseLayout(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openAddExpenseDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('Thêm khoản phí'),
    );
  }
}
