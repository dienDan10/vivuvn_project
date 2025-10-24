import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import '../../data/enums/budget_sort_option.dart';

class BudgetControl extends ConsumerStatefulWidget {
  const BudgetControl({super.key});

  @override
  ConsumerState<BudgetControl> createState() => _BudgetControlState();
}

class _BudgetControlState extends ConsumerState<BudgetControl> {
  void _handleSortChange(final BudgetSortOption option) {
    ref.read(budgetControllerProvider.notifier).sortBudgetItem(option);
  }

  @override
  Widget build(final BuildContext context) {
    final currentSort = ref.watch(
      budgetControllerProvider.select((final state) => state.currentSort),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Các chi phí',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          InkWell(
            onTap: () => _showSortOptions(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(currentSort.icon, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    currentSort.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(final BuildContext context) {
    final currentSort = ref.read(
      budgetControllerProvider.select((final state) => state.currentSort),
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sắp xếp theo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ...BudgetSortOption.values.map((final option) {
              final isSelected = option == currentSort;
              return ListTile(
                leading: Icon(
                  option.icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[700],
                ),
                title: Text(
                  option.label,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  _handleSortChange(option);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
