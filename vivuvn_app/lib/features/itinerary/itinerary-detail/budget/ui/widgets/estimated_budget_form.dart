import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/helper/number_format_helper.dart';
import '../../../../../../common/toast/global_toast.dart';
import '../../controller/budget_controller.dart';
import '../../data/dto/update_budget_request.dart';
import 'budget_input_field.dart';
import 'submit_button.dart';

class EstimatedBudgetForm extends ConsumerStatefulWidget {
  final double? initialEstimatedBudget;

  const EstimatedBudgetForm({super.key, this.initialEstimatedBudget});

  @override
  ConsumerState<EstimatedBudgetForm> createState() =>
      _EstimatedBudgetFormState();
}

class _EstimatedBudgetFormState extends ConsumerState<EstimatedBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  final _focusNode = FocusNode();
  String _selectedCurrency = 'VND';
  static const double _fixedExchangeRate = 24000.0;

  @override
  void initState() {
    super.initState();
    // Pre-fill with initial budget if available
    final initialBudget = widget.initialEstimatedBudget;
    _amountController = TextEditingController(
      text: initialBudget != null && initialBudget > 0
          ? formatWithThousandsFromNum(initialBudget)
          : '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double? get _vndEquivalent {
    if (_selectedCurrency != 'USD') return null;
    final amount = double.tryParse(
      _amountController.text.replaceAll(',', '').trim(),
    );
    if (amount == null) return null;
    return amount * _fixedExchangeRate;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // If empty, treat as 0
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '').trim()) ??
        0.0;

    // Convert to VND if USD selected
    double vndAmount = amount;
    if (_selectedCurrency == 'USD') {
      vndAmount = amount * _fixedExchangeRate;
    }

    // Validate max 500 million VND
    if (vndAmount > 500000000) {
      if (mounted) {
        GlobalToast.showErrorToast(
          context,
          message: 'Ngân sách dự kiến không được vượt quá 500 triệu VNĐ',
        );
      }
      return;
    }

    final controller = ref.read(budgetControllerProvider.notifier);
    final state = ref.read(budgetControllerProvider);

    if (state.itineraryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy itinerary ID')),
        );
      }
      return;
    }

    final request = UpdateBudgetRequest(
      itineraryId: state.itineraryId!,
      estimatedBudget: vndAmount,
    );

    final success = await controller.updateBudget(request);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        final errorMsg = ref.read(budgetControllerProvider).error;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg ?? 'Có lỗi xảy ra')));
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final isLoading = ref.watch(
      budgetControllerProvider.select((final state) => state.isLoading),
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Nhập ngân sách dự kiến',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),

                // Currency toggle
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('VND')),
                        selected: _selectedCurrency == 'VND',
                        onSelected: isLoading
                            ? null
                            : (final selected) {
                                if (selected) {
                                  setState(() => _selectedCurrency = 'VND');
                                }
                              },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('USD')),
                        selected: _selectedCurrency == 'USD',
                        onSelected: isLoading
                            ? null
                            : (final selected) {
                                if (selected) {
                                  setState(() => _selectedCurrency = 'USD');
                                }
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount input
                BudgetInputField(
                  controller: _amountController,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}),
                ),

                // USD conversion section - show fixed exchange rate
                if (_selectedCurrency == 'USD') ...[
                  const SizedBox(height: 12),
                  Text(
                    'Tỉ giá cố định: 1 USD = ${NumberFormat('#,###', 'vi_VN').format(_fixedExchangeRate)} VND',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (final context) {
                      final vnd = _vndEquivalent;
                      if (vnd != null) {
                        return Text(
                          'Tương đương: ${formatter.format(vnd.round())} VND',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],

                const SizedBox(height: 20),
                SubmitButton(
                  text: 'Lưu',
                  onPressed: isLoading
                      ? null
                      : () {
                          _onSubmit();
                        },
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
