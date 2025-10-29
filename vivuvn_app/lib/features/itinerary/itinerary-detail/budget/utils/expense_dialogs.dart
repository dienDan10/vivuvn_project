import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../controller/budget_controller.dart';
import '../data/dto/delete_budget_item_request.dart';
import '../data/models/budget_items.dart';
import '../ui/widgets/add_expense_layout.dart';

/// Utility class for expense-related dialogs
class ExpenseDialogs {
  const ExpenseDialogs._();

  /// Show edit expense form in modal bottom sheet
  static void showEditForm(final BuildContext context, final BudgetItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      constraints: const BoxConstraints.expand(),
      backgroundColor: Colors.transparent,
      builder: (final context) =>
          AddExpenseLayout(title: 'Chỉnh sửa chi phí', initialItem: item),
    );
  }

  /// Show delete confirmation dialog and handle deletion
  static Future<void> showDeleteConfirmation(
    final BuildContext context,
    final WidgetRef ref,
    final BudgetItem item,
  ) async {
    final confirmed = await _showConfirmDialog(context, item.name);

    if (confirmed && context.mounted) {
      await _deleteItem(context, ref, item);
    }
  }

  /// Show confirmation dialog
  static Future<bool> _showConfirmDialog(
    final BuildContext context,
    final String itemName,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "$itemName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Delete budget item via API
  static Future<void> _deleteItem(
    final BuildContext context,
    final WidgetRef ref,
    final BudgetItem item,
  ) async {
    if (item.id == null) {
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Không tìm thấy ID chi phí',
        );
      }
      return;
    }

    final controller = ref.read(budgetControllerProvider.notifier);
    final state = ref.read(budgetControllerProvider);

    final request = DeleteBudgetItemRequest(
      itemId: item.id!,
      itineraryId: state.itineraryId,
    );

    await controller.deleteBudgetItem(request);
  }
}
