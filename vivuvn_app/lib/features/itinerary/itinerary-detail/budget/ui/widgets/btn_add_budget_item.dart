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
    return InkWell(
      onTap: () => _openAddExpenseDialog(context),
      child: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 20.0,
          top: 12.0,
          bottom: 12.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              'Thêm khoản phí',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
