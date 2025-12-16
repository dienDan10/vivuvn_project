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

    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Các chi phí',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: theme.colorScheme.onSurface,
            ),
          ),
          InkWell(
            onTap: () => _showSortOptions(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    currentSort.icon,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentSort.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_drop_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
      backgroundColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      barrierColor: Theme.of(context)
          .colorScheme
          .scrim
          .withValues(alpha: 0.4),
      builder: (final context) {
        final theme = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.outline.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sắp xếp theo',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...BudgetSortOption.values.map((final option) {
              final isSelected = option == currentSort;
              return ListTile(
                leading: Icon(
                  option.icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  option.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: theme.colorScheme.primary,
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
