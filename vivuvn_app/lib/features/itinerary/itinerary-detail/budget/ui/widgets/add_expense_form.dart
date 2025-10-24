import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import '../../data/models/budget_items.dart';
import '../../state/expense_form_notifier.dart';
import '../../utils/budget_constants.dart';
import '../../utils/expense_form_submit_handler.dart';
import 'field_amount.dart';
import 'field_date.dart';
import 'field_error_text.dart';
import 'field_name.dart';
import 'field_type_picker.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  final Function(VoidCallback)? onRegisterSaveCallback;
  final BudgetItem? initialItem; // For edit mode

  const AddExpenseForm({
    super.key,
    this.onRegisterSaveCallback,
    this.initialItem,
  });

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  /// Submit form thông qua ExpenseFormSubmitHandler
  Future<void> _submit() async {
    final shouldClose = await ExpenseFormSubmitHandler.submit(
      context: context,
      ref: ref,
      formKey: _formKey,
      nameController: nameController,
      amountController: amountController,
      initialItem: widget.initialItem,
      exchangeRate: BudgetConstants.exchangeRate,
    );

    if (shouldClose && mounted) {
      Navigator.pop(context);
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

    // Register save callback with parent
    widget.onRegisterSaveCallback?.call(_submit);

    // Load budget types and initialize form after widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pre-fill data if editing
      if (widget.initialItem != null) {
        final item = widget.initialItem!;
        final formNotifier = ref.read(expenseFormProvider.notifier);

        nameController.text = item.name;
        amountController.text = item.cost.toStringAsFixed(0);

        // Initialize form state with item data
        formNotifier.initializeWithItem(item);
      }

      final controller = ref.read(budgetControllerProvider.notifier);
      final state = ref.read(budgetControllerProvider);

      if (state.itineraryId != null && state.types.isEmpty) {
        controller.loadBudgetTypes(state.itineraryId!);
      }

      // If editing and budgetTypeObj is null, resolve typeId from loaded types
      if (widget.initialItem != null &&
          widget.initialItem!.budgetTypeObj == null) {
        final formState = ref.read(expenseFormProvider);
        if (formState.selectedTypeId == 0) {
          final typeId = controller.getBudgetTypeIdByName(
            formState.selectedType,
          );
          if (typeId != null) {
            ref
                .read(expenseFormProvider.notifier)
                .setType(typeId, formState.selectedType);
          }
        }
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final formState = ref.watch(expenseFormProvider);
    final formNotifier = ref.read(expenseFormProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FieldName(controller: nameController),
          const SizedBox(height: 12),

          FieldAmount(
            controller: amountController,
            onCurrencyChanged: (final isUSDSelected) {
              formNotifier.setCurrency(isUSDSelected);
            },
          ),
          const SizedBox(height: 12),

          Consumer(
            builder: (final context, final ref, final child) {
              final types = ref.watch(budgetControllerProvider).types;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTypePicker(
                    selectedType: formState.selectedType,
                    budgetTypes: types,
                    onSelected: (final typeId, final typeName) {
                      formNotifier.setType(typeId!, typeName);
                    },
                  ),
                  FieldErrorText(errorMessage: formState.typeError),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldDate(
                selectedDate: formState.selectedDate,
                onSelected: (final date) {
                  if (date != null) {
                    formNotifier.setDate(date);
                  }
                },
              ),
              FieldErrorText(errorMessage: formState.dateError),
            ],
          ),
        ],
      ),
    );
  }
}
