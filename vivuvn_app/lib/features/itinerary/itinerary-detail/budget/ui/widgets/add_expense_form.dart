import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/budget_controller.dart';
import '../../data/dto/add_budget_item_request.dart';
import 'field_amount.dart';
import 'field_date.dart';
import 'field_name.dart';
import 'field_type_picker.dart';
import 'submit_button.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  const AddExpenseForm({super.key});

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  String selectedType = 'Chưa chọn';
  int selectedTypeId = 0;
  DateTime? selectedDate;
  String? dateError;
  String? typeError;

  Future<void> _submit() async {
    // Reset error states
    setState(() {
      dateError = null;
      typeError = null;
    });

    // Validate form fields
    final formValid = _formKey.currentState!.validate();

    // Validate date
    if (selectedDate == null) {
      setState(() {
        dateError = 'Vui lòng chọn ngày';
      });
    }

    // Validate budget type
    if (selectedTypeId == 0) {
      setState(() {
        typeError = 'Vui lòng chọn loại chi phí';
      });
    }

    // Stop if any validation failed
    if (!formValid || dateError != null || typeError != null) {
      return;
    }

    final controller = ref.read(budgetControllerProvider.notifier);
    final state = ref.read(budgetControllerProvider);

    if (state.itineraryId == null) {
      if (mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Không tìm thấy itinerary ID',
        );
      }
      return;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null) {
      if (mounted) {
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: 'Số tiền không hợp lệ',
        );
      }
      return;
    }

    final request = AddBudgetItemRequest(
      itineraryId: state.itineraryId!,
      name: nameController.text.trim(),
      cost: amount,
      budgetTypeId: selectedTypeId,
      date: selectedDate!,
    );

    final success = await controller.addBudgetItem(request);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        GlobalToast.showSuccessToast(
          context,
          title: 'Thành công',
          message: 'Thêm chi phí thành công',
        );
      } else {
        final errorMsg = ref.read(budgetControllerProvider).error;
        GlobalToast.showErrorToast(
          context,
          title: 'Lỗi',
          message: errorMsg ?? 'Có lỗi xảy ra',
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load budget types when form opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(budgetControllerProvider);
      if (state.itineraryId != null && state.types.isEmpty) {
        ref
            .read(budgetControllerProvider.notifier)
            .loadBudgetTypes(state.itineraryId!);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thêm chi phí',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              FieldName(controller: nameController),
              const SizedBox(height: 12),

              FieldAmount(controller: amountController),
              const SizedBox(height: 12),

              Consumer(
                builder: (final context, final ref, final child) {
                  final types = ref.watch(budgetControllerProvider).types;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldTypePicker(
                        selectedType: selectedType,
                        budgetTypes: types,
                        onSelected: (final typeId, final typeName) {
                          setState(() {
                            selectedTypeId = typeId!;
                            selectedType = typeName;
                            typeError = null; // Clear error when selected
                          });
                        },
                      ),
                      if (typeError != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            typeError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldDate(
                    selectedDate: selectedDate,
                    onSelected: (final date) {
                      setState(() {
                        selectedDate = date ?? selectedDate;
                        dateError = null; // Clear error when selected
                      });
                    },
                  ),
                  if (dateError != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        dateError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              SubmitButton(text: 'Xong', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
