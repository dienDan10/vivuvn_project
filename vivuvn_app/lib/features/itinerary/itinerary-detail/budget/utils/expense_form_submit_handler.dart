import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/toast/global_toast.dart';
import '../controller/budget_controller.dart';
import '../controller/expense_bill_controller.dart';
import '../data/api/expense_bill_api.dart';
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
    required final TextEditingController detailsController,
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
        detailsController: detailsController,
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
    final budgetState = ref.read(budgetControllerProvider);

    if (budgetState.itineraryId == null) {
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Không tìm thấy itinerary ID',
        );
      }
      return false;
    }

    final sanitized = amountController.text.replaceAll(',', '').trim();
    final amount = double.tryParse(sanitized);
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
    bool dataSuccess;
    BudgetItem? createdItem;

    if (isEditing) {
      dataSuccess = await _updateBudgetItem(
        controller: controller,
        state: budgetState,
        initialItem: initialItem,
        nameController: nameController,
        detailsController: detailsController,
        amountInVND: amountInVND,
        formState: formState,
      );
    } else {
      createdItem = await _addBudgetItem(
        controller: controller,
        state: budgetState,
        nameController: nameController,
        detailsController: detailsController,
        amountInVND: amountInVND,
        formState: formState,
      );
      dataSuccess = createdItem != null;
    }

    // Sau khi gọi API data xong, luôn đọc lại budgetState mới nhất
    final latestBudgetState = ref.read(budgetControllerProvider);

    String? uploadError;

    // Chỉ upload ảnh nếu lưu data thành công
    if (dataSuccess && latestBudgetState.itineraryId != null) {
      final billState = ref.read(expenseBillControllerProvider);
      // Chỉ upload các file local (bỏ qua ảnh URL đã có sẵn trên server).
      final localFiles = billState.localImagePaths
          .where((final path) => !path.startsWith('http'))
          .toList();

      if (localFiles.isNotEmpty) {
        try {
          final expenseBillApi = ref.read(expenseBillApiProvider);

          // Xác định budgetItemId:
          // - Nếu chỉnh sửa: dùng luôn id của item hiện tại
          // - Nếu thêm mới: dùng id từ item vừa tạo
          final int? budgetItemId =
              isEditing ? initialItem.id : createdItem?.id;

          if (budgetItemId != null) {
            final imageUrl = await expenseBillApi.uploadBillsForBudgetItem(
              itineraryId: latestBudgetState.itineraryId!,
              budgetItemId: budgetItemId,
              filePaths: localFiles,
            );

            // Nếu upload thành công và có imageUrl, gọi API update để lưu vào billPhotoUrl
            if (imageUrl != null) {
              // Lấy lại payer hiện tại từ budgetState để không làm mất thông tin người trả tiền
              final latestItem = latestBudgetState.items
                  .where((final item) => item.id == budgetItemId)
                  .cast<BudgetItem?>()
                  .firstOrNull;
              final int? currentPayerId =
                  latestItem?.paidByMember?.memberId ??
                      (isEditing
                          ? initialItem.paidByMember?.memberId
                          : createdItem?.paidByMember?.memberId);

              final photoUpdateReq = UpdateBudgetItemRequest(
                itineraryId: latestBudgetState.itineraryId!,
                itemId: budgetItemId,
                payerMemberId: currentPayerId,
                billPhotoUrl: imageUrl,
              );
              await controller.updateBudgetItem(
                photoUpdateReq,
                reloadBudget: false,
              );
            }

            // Clear ảnh local sau khi upload thành công
            ref.read(expenseBillControllerProvider.notifier).clearBills();
          }
        } catch (_) {
          uploadError = 'Upload ảnh hóa đơn không thành công';
        }
      }
    }

    // Sau khi hoàn thành cả data + (có thể) upload ảnh, chỉ reload budget một lần
    if (dataSuccess && budgetState.itineraryId != null) {
      await controller.loadBudget(budgetState.itineraryId);
    }

    if (context.mounted) {
      _showResultToast(
        context: context,
        success: dataSuccess,
        isEditing: isEditing,
        errorMsg: ref.read(budgetControllerProvider).error,
      );

      // Nếu upload ảnh thất bại nhưng data đã lưu thành công,
      // vẫn giữ data và chỉ thông báo lỗi upload.
      if (dataSuccess && uploadError != null) {
        GlobalToast.showErrorToast(
          context,
          title: 'Thông báo',
          message: uploadError,
        );
      }
    }

    return dataSuccess;
  }

  /// Check if form has any changes compared to initial item
  static bool _hasChanges({
    required final BudgetItem initialItem,
    required final TextEditingController nameController,
    required final TextEditingController amountController,
    required final TextEditingController detailsController,
    required final dynamic formState,
    required final double exchangeRate,
  }) {
    final currentName = nameController.text.trim();
    final currentAmount = double.tryParse(
      amountController.text.replaceAll(',', '').trim(),
    );

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
        formState.selectedDate?.day == initialItem.date.day &&
        (formState.payerMemberId == (initialItem.paidByMember?.memberId)) &&
        ((detailsController.text.trim()) == (initialItem.details ?? ''));

    return !nothingChanged;
  }

  /// Update existing budget item
  static Future<bool> _updateBudgetItem({
    required final dynamic controller,
    required final dynamic state,
    required final BudgetItem initialItem,
    required final TextEditingController nameController,
    required final TextEditingController detailsController,
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
      payerMemberId: formState.payerMemberId,
      details: detailsController.text.trim(),
    );
    // ignore: avoid_print
    return await controller.updateBudgetItem(
      updateRequest,
      reloadBudget: false,
    );
  }

  /// Add new budget item
  static Future<BudgetItem?> _addBudgetItem({
    required final dynamic controller,
    required final dynamic state,
    required final TextEditingController nameController,
    required final TextEditingController detailsController,
    required final double amountInVND,
    required final dynamic formState,
  }) async {
    final addRequest = AddBudgetItemRequest(
      itineraryId: state.itineraryId!,
      name: nameController.text.trim(),
      cost: amountInVND,
      budgetTypeId: formState.selectedTypeId,
      date: formState.selectedDate!,
      payerMemberId: formState.payerMemberId,
      details: detailsController.text.trim(),
    );
    // ignore: avoid_print
    final created = await controller.addBudgetItem(
      addRequest,
      reloadBudget: false,
    );
    return created as BudgetItem?;
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
        // Nếu lỗi từ API data, coi như thêm/chỉnh sửa chi phí thất bại
        message: errorMsg ??
            (isEditing
                ? 'Chỉnh sửa chi phí thất bại'
                : 'Thêm chi phí thất bại'),
      );
    }
  }
}
