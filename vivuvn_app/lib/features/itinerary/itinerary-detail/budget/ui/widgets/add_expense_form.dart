import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/helper/number_format_helper.dart';
import '../../controller/budget_controller.dart';
import '../../controller/expense_bill_controller.dart';
import '../../data/models/budget_items.dart';
import '../../state/expense_form_notifier.dart';
import '../../utils/budget_constants.dart';
import '../../utils/expense_form_submit_handler.dart';
import 'bill_attachment_section.dart';
import 'field_amount.dart';
import 'field_date.dart';
import 'field_details.dart';
import 'field_error_text.dart';
import 'field_name.dart';
import 'field_payer_picker.dart';
import 'field_type_picker.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  final Function(VoidCallback)? onRegisterSaveCallback;
  final BudgetItem? initialItem; // For edit mode
  final bool isReadOnly;

  const AddExpenseForm({
    super.key,
    this.onRegisterSaveCallback,
    this.initialItem,
    this.isReadOnly = false,
  });

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final detailsController = TextEditingController();
  bool _isSubmitting = false;

  /// Submit form thông qua ExpenseFormSubmitHandler
  Future<void> _submit() async {
    // Tránh submit nhiều lần liên tiếp
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final shouldClose = await ExpenseFormSubmitHandler.submit(
      context: context,
      ref: ref,
      formKey: _formKey,
      nameController: nameController,
      amountController: amountController,
      detailsController: detailsController,
      initialItem: widget.initialItem,
      exchangeRate: BudgetConstants.exchangeRate,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (shouldClose) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    detailsController.dispose();
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
        final billController = ref.read(expenseBillControllerProvider.notifier);

        nameController.text = item.name;
        amountController.text = formatWithThousandsFromNum(item.cost);
        detailsController.text = item.details ?? '';

        // Nếu item có billPhotoUrl, hiển thị trước trong preview (dùng URL)
        if ((item.billPhotoUrl ?? '').isNotEmpty) {
          billController.setInitialBillFromNetwork(item.billPhotoUrl!);
        }

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
        if (formState.selectedTypeId == 0 &&
            formState.selectedType.isNotEmpty) {
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
    final budgetState = ref.watch(budgetControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = (screenWidth / 400).clamp(0.85, 1.15);
    final double baseSpacing = (15 * scale).clamp(11, 20).toDouble();
    final double smallSpacing = (baseSpacing * 0.6).clamp(7, 13).toDouble();
    final double mediumSpacing = (baseSpacing * 0.9).clamp(9, 16).toDouble();

    // Khi types đã được load sau đó, đảm bảo map lại typeId cho item đang edit (nếu cần)
    if (widget.initialItem != null &&
        widget.initialItem!.budgetTypeObj == null &&
        budgetState.types.isNotEmpty &&
        formState.selectedTypeId == 0 &&
        formState.selectedType.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(budgetControllerProvider.notifier);
        final typeId = controller.getBudgetTypeIdByName(formState.selectedType);
        if (typeId != null) {
          ref
              .read(expenseFormProvider.notifier)
              .setType(typeId, formState.selectedType);
        }
      });
    }

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: smallSpacing,
              bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FieldName(
                    controller: nameController,
                    enabled: !widget.isReadOnly,
                  ),
                  SizedBox(height: baseSpacing),

                  // Payer picker
                  FieldPayerPicker(enabled: !widget.isReadOnly),
                  SizedBox(height: baseSpacing),

                  FieldAmount(
                    controller: amountController,
                    enabled: !widget.isReadOnly,
                    onCurrencyChanged: (final isUSDSelected) {
                      formNotifier.setCurrency(isUSDSelected);
                    },
                  ),
                  SizedBox(height: baseSpacing),

                  Consumer(
                    builder: (final context, final ref, final child) {
                      final types = ref.watch(budgetControllerProvider).types;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldTypePicker(
                            selectedType: formState.selectedType,
                            budgetTypes: types,
                            enabled: !widget.isReadOnly,
                            onSelected: (final typeId, final typeName) {
                              formNotifier.setType(typeId!, typeName);
                            },
                          ),
                          FieldErrorText(errorMessage: formState.typeError),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: mediumSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldDate(
                        selectedDate: formState.selectedDate,
                        enabled: !widget.isReadOnly,
                        onSelected: (final date) {
                          if (date != null) {
                            formNotifier.setDate(date);
                          }
                        },
                      ),
                      FieldErrorText(errorMessage: formState.dateError),
                    ],
                  ),
                  SizedBox(height: mediumSpacing),

                  // Optional details field
                  FieldDetails(
                    controller: detailsController,
                    enabled: !widget.isReadOnly,
                  ),
                  SizedBox(height: baseSpacing),

                  // Phần upload + preview ảnh bill/hóa đơn
                  BillAttachmentSection(enabled: !widget.isReadOnly),
                  SizedBox(height: baseSpacing),
                ],
              ),
            ),
          ),

          if (_isSubmitting)
            Positioned.fill(
              child: AbsorbPointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.scrim.withValues(alpha: 0.25),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
