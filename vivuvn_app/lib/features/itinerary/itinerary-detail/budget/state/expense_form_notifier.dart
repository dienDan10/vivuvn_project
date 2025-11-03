import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/budget_items.dart';
import 'expense_form_state.dart';

final expenseFormProvider =
    StateNotifierProvider.autoDispose<ExpenseFormNotifier, ExpenseFormState>(
      (final ref) => ExpenseFormNotifier(),
    );

class ExpenseFormNotifier extends StateNotifier<ExpenseFormState> {
  ExpenseFormNotifier() : super(const ExpenseFormState());

  /// Initialize form with existing item data (for edit mode)
  void initializeWithItem(final BudgetItem item) {
    state = ExpenseFormState(
      name: item.name,
      amount: item.cost.toStringAsFixed(0),
      selectedType: item.budgetType,
      selectedTypeId: item.budgetTypeObj?.budgetTypeId ?? 0,
      selectedDate: item.date,
      payerMemberId: item.paidByMember?.memberId,
      payerMemberName: item.paidByMember?.username,
    );
  }

  /// Update name
  void setName(final String name) {
    state = state.copyWith(name: name);
  }

  /// Update amount
  void setAmount(final String amount) {
    state = state.copyWith(amount: amount);
  }

  /// Update selected type
  void setType(final int typeId, final String typeName) {
    state = state.copyWith(
      selectedTypeId: typeId,
      selectedType: typeName,
      typeError: null, // Clear error when type is selected
    );
  }

  /// Resolve type ID from type name (when budgetTypeObj is null)
  void setTypeIdByName(final int typeId) {
    state = state.copyWith(selectedTypeId: typeId);
  }

  /// Update selected date
  void setDate(final DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      dateError: null, // Clear error when date is selected
    );
  }

  /// Update currency toggle
  void setCurrency(final bool isUSD) {
    state = state.copyWith(isUSD: isUSD);
  }

  void setPayer(final int? memberId, [final String? memberName]) {
    // Debug log before update
    // ignore: avoid_print
    print('[ExpenseForm] setPayer -> id: $memberId, name: ${memberName ?? 'null'}');

    state = state.copyWith(
      payerMemberId: memberId,
      payerMemberName: memberName,
    );

    // Debug log after update
    // ignore: avoid_print
    print('[ExpenseForm] updated -> payerMemberId: ${state.payerMemberId?.toString() ?? 'null'}, payerMemberName: ${state.payerMemberName ?? 'null'}');
  }

  /// Set date error
  void setDateError(final String error) {
    state = state.copyWith(dateError: error);
  }

  /// Set type error
  void setTypeError(final String error) {
    state = state.copyWith(typeError: error);
  }

  /// Clear all errors
  void clearErrors() {
    state = state.clearErrors();
  }

  /// Reset form to initial state
  void reset() {
    state = const ExpenseFormState();
  }

  /// Validate form
  bool validate() {
    bool isValid = true;

    // Validate date
    if (state.selectedDate == null) {
      state = state.copyWith(dateError: 'Vui lòng chọn ngày');
      isValid = false;
    }

    // Validate budget type
    if (state.selectedTypeId == 0) {
      state = state.copyWith(typeError: 'Vui lòng chọn loại chi phí');
      isValid = false;
    }

    return isValid;
  }
}
