class ExpenseFormState {
  final String name;
  final String amount;
  final String selectedType;
  final int selectedTypeId;
  final DateTime? selectedDate;
  final String? dateError;
  final String? typeError;
  final bool isUSD;

  const ExpenseFormState({
    this.name = '',
    this.amount = '',
    this.selectedType = 'Chưa chọn',
    this.selectedTypeId = 0,
    this.selectedDate,
    this.dateError,
    this.typeError,
    this.isUSD = false,
  });

  ExpenseFormState copyWith({
    final String? name,
    final String? amount,
    final String? selectedType,
    final int? selectedTypeId,
    final DateTime? selectedDate,
    final String? dateError,
    final String? typeError,
    final bool? isUSD,
  }) {
    return ExpenseFormState(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      selectedType: selectedType ?? this.selectedType,
      selectedTypeId: selectedTypeId ?? this.selectedTypeId,
      selectedDate: selectedDate ?? this.selectedDate,
      dateError: dateError,
      typeError: typeError,
      isUSD: isUSD ?? this.isUSD,
    );
  }

  ExpenseFormState clearErrors() {
    return copyWith(dateError: null, typeError: null);
  }
}
