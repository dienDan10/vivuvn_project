import 'package:flutter/material.dart';

import '../../data/models/budget_type.dart';
import '../../utils/budget_type_icons.dart';

/// Widget cho phép chọn loại chi phí từ danh sách
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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final modalContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(modalContext),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const Center(
                  child: Text(
                    'Chọn loại chi phí',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: budgetTypes.length,
              itemBuilder: (final context, final index) {
                final type = budgetTypes[index];
                final isSelected = selectedType == type.name;

                return InkWell(
                  onTap: () {
                    onSelected(type.budgetTypeId, type.name);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          BudgetTypeIcons.getIconForType(type.name),
                          size: 32,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[700],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final isSelected = selectedType != 'Chưa chọn';
    final displayText = isSelected ? selectedType : 'Chọn loại chi phí';
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _pickType(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Loại chi phí',
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? BudgetTypeIcons.getIconForType(selectedType)
                  : Icons.category_outlined,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? theme.colorScheme.onSurface : theme.hintColor,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
