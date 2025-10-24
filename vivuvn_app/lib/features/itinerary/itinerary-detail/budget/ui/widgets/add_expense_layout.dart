import 'package:flutter/material.dart';

import '../../data/models/budget_items.dart';
import '../../utils/budget_constants.dart';
import 'add_expense_form.dart';

/// Layout wrapper cho form thêm/chỉnh sửa chi tiêu
class AddExpenseLayout extends StatefulWidget {
  final String title;
  final BudgetItem? initialItem;

  const AddExpenseLayout({
    super.key,
    this.title = 'Thêm chi phí',
    this.initialItem,
  });

  @override
  State<AddExpenseLayout> createState() => _AddExpenseLayoutState();
}

class _AddExpenseLayoutState extends State<AddExpenseLayout> {
  VoidCallback? _onSave;

  /// Register callback từ form để gọi khi nhấn nút Lưu
  void _registerSaveCallback(final VoidCallback callback) {
    _onSave = callback;
  }

  /// Handle save button press
  void _handleSave() {
    _onSave?.call();
  }

  /// Handle close button press
  void _handleClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: EdgeInsets.only(
        left: BudgetConstants.sectionSpacing,
        right: BudgetConstants.sectionSpacing,
        top: kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: BudgetConstants.sectionSpacing),
          _buildForm(),
        ],
      ),
    );
  }

  /// Build header với nút đóng và lưu
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.close), onPressed: _handleClose),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: _handleSave,
          child: const Text(
            'Lưu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// Build form
  Widget _buildForm() {
    return Expanded(
      child: AddExpenseForm(
        onRegisterSaveCallback: _registerSaveCallback,
        initialItem: widget.initialItem,
      ),
    );
  }
}
