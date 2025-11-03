class ExpenseFormState {
  static const Object _unset = Object();
  final String name;
  final String amount;
  final String selectedType;
  final int selectedTypeId;
  final DateTime? selectedDate;
  final String? dateError;
  final String? typeError;
  final bool isUSD;
  final int? payerMemberId;
  final String? payerMemberName;

  const ExpenseFormState({
    this.name = '',
    this.amount = '',
    this.selectedType = 'Chưa chọn',
    this.selectedTypeId = 0,
    this.selectedDate,
    this.dateError,
    this.typeError,
    this.isUSD = false,
    this.payerMemberId,
    this.payerMemberName,
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
    final Object? payerMemberId = _unset,
    final Object? payerMemberName = _unset,
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
      payerMemberId: identical(payerMemberId, _unset)
          ? this.payerMemberId
          : payerMemberId as int?,
      payerMemberName: identical(payerMemberName, _unset)
          ? this.payerMemberName
          : payerMemberName as String?,
    );
  }

  ExpenseFormState clearErrors() {
    return copyWith(dateError: null, typeError: null);
  }
}
