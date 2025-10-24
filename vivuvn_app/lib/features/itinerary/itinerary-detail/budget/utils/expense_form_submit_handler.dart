import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/toast/global_toast.dart';
import '../controller/budget_controller.dart';
import '../data/dto/add_budget_item_request.dart';
import '../data/dto/update_budget_item_request.dart';
import '../data/models/budget_items.dart';
import '../state/expense_form_notifier.dart';

/// Helper class xử lý submit logic cho expense form
class ExpenseFormSubmitHandler {
  const ExpenseFormSubmitHandler._();

  /// Submit form - Add hoặc Update budget item
  ///
  /// Returns: true nếu cần close form, false nếu có lỗi validation
  static Future<bool> submit({
    required final BuildContext context,
    required final WidgetRef ref,
    required final GlobalKey<FormState> formKey,
    required final TextEditingController nameController,
    required final TextEditingController amountController,
    required final BudgetItem? initialItem,
    required final double exchangeRate,
  }) async {
    final formNotifier = ref.read(expenseFormProvider.notifier);
    final formState = ref.read(expenseFormProvider);

    // Check if editing mode and nothing changed
    if (initialItem != null) {
      final hasChanges = _hasChanges(
        initialItem: initialItem,
        nameController: nameController,
        amountController: amountController,
        formState: formState,
        exchangeRate: exchangeRate,
      );

      // If nothing changed, just close the form
      if (!hasChanges) {
        return true; // Signal to close form
      }
    }

    // Clear errors first
    formNotifier.clearErrors();

    // Validate form fields
    final formValid = formKey.currentState!.validate();
    final stateValid = formNotifier.validate();

    // Stop if any validation failed
    if (!formValid || !stateValid) {
      return false;
    }

    final controller = ref.read(budgetControllerProvider.notifier);
    final state = ref.read(budgetControllerProvider);

    if (state.itineraryId == null) {
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Không tìm thấy itinerary ID',
        );
      }
      return false;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null) {
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Số tiền không hợp lệ',
        );
      }
      return false;
    }

    // Convert to VND if entered in USD
    final amountInVND = formState.isUSD ? amount * exchangeRate : amount;

    // Check if editing or adding
    final bool isEditing = initialItem != null;
    bool success;

    if (isEditing) {
      success = await _updateBudgetItem(
        controller: controller,
        state: state,
        initialItem: initialItem,
        nameController: nameController,
        amountInVND: amountInVND,
        formState: formState,
      );
    } else {
      success = await _addBudgetItem(
        controller: controller,
        state: state,
        nameController: nameController,
        amountInVND: amountInVND,
        formState: formState,
      );
    }

    if (context.mounted) {
      _showResultToast(
        context: context,
        success: success,
        isEditing: isEditing,
        errorMsg: ref.read(budgetControllerProvider).error,
      );
    }

    return success;
  }

  /// Check if form has any changes compared to initial item
  static bool _hasChanges({
    required final BudgetItem initialItem,
    required final TextEditingController nameController,
    required final TextEditingController amountController,
    required final dynamic formState,
    required final double exchangeRate,
  }) {
    final currentName = nameController.text.trim();
    final currentAmount = double.tryParse(amountController.text.trim());

    // Convert current amount to VND if needed
    final currentAmountInVND = currentAmount != null
        ? (formState.isUSD ? currentAmount * exchangeRate : currentAmount)
        : null;

    // Check if nothing changed
    final bool nothingChanged =
        currentName == initialItem.name &&
        currentAmountInVND != null &&
        (currentAmountInVND - initialItem.cost).abs() < 0.01 &&
        formState.selectedTypeId ==
            (initialItem.budgetTypeObj?.budgetTypeId ?? 0) &&
        formState.selectedDate?.year == initialItem.date.year &&
        formState.selectedDate?.month == initialItem.date.month &&
        formState.selectedDate?.day == initialItem.date.day;

    return !nothingChanged;
  }

  /// Update existing budget item
  static Future<bool> _updateBudgetItem({
    required final dynamic controller,
    required final dynamic state,
    required final BudgetItem initialItem,
    required final TextEditingController nameController,
    required final double amountInVND,
    required final dynamic formState,
  }) async {
    final updateRequest = UpdateBudgetItemRequest(
      itineraryId: state.itineraryId!,
      itemId: initialItem.id!,
      name: nameController.text.trim(),
      cost: amountInVND,
      budgetTypeId: formState.selectedTypeId,
      date: formState.selectedDate!,
    );
    return await controller.updateBudgetItem(updateRequest);
  }

  /// Add new budget item
  static Future<bool> _addBudgetItem({
    required final dynamic controller,
    required final dynamic state,
    required final TextEditingController nameController,
    required final double amountInVND,
    required final dynamic formState,
  }) async {
    final addRequest = AddBudgetItemRequest(
      itineraryId: state.itineraryId!,
      name: nameController.text.trim(),
      cost: amountInVND,
      budgetTypeId: formState.selectedTypeId,
      date: formState.selectedDate!,
    );
    return await controller.addBudgetItem(addRequest);
  }

  /// Show success or error toast
  static void _showResultToast({
    required final BuildContext context,
    required final bool success,
    required final bool isEditing,
    required final String? errorMsg,
  }) {
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        title: 'Thành công',
        message: isEditing
            ? 'Cập nhật chi phí thành công'
            : 'Thêm chi phí thành công',
      );
    } else {
      GlobalToast.showErrorToast(
        context,
        title: 'Lỗi',
        message: errorMsg ?? 'Có lỗi xảy ra',
      );
    }
  }
}
