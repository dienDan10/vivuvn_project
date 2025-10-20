import 'package:flutter/material.dart';

import '../../data/models/budget_type.dart';

class FieldTypePicker extends StatelessWidget {
  final String selectedType;
  final List<BudgetType> budgetTypes;
  final void Function(int? typeId, String typeName) onSelected;

  const FieldTypePicker({
    super.key,
    required this.selectedType,
    required this.budgetTypes,
    required this.onSelected,
  });

  Future<void> _pickType(final BuildContext context) async {
    if (budgetTypes.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đang tải loại chi phí...')));
      return;
    }

    final result = await showModalBottomSheet<(int, String)?>(
      context: context,
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: budgetTypes.length,
        itemBuilder: (final context, final index) {
          final type = budgetTypes[index];
          return ListTile(
            title: Text(type.name),
            onTap: () => Navigator.pop(context, (type.budgetTypeId, type.name)),
          );
        },
      ),
    );

    if (result != null) {
      onSelected(result.$1, result.$2);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: Text(selectedType),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () => _pickType(context),
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
