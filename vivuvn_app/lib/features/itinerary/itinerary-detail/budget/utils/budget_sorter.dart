import '../data/models/budget_items.dart';
import '../ui/widgets/budget_control.dart';

/// Utility class for sorting budget items
class BudgetSorter {
  const BudgetSorter._();

  /// Sort budget items based on the given option
  static List<BudgetItem> sort(
    final List<BudgetItem> items,
    final BudgetSortOption option,
  ) {
    final sortedItems = List<BudgetItem>.from(items);

    switch (option) {
      case BudgetSortOption.dateNewest:
        sortedItems.sort((final a, final b) => b.date.compareTo(a.date));
        break;
      case BudgetSortOption.dateOldest:
        sortedItems.sort((final a, final b) => a.date.compareTo(b.date));
        break;
      case BudgetSortOption.amountHighest:
        sortedItems.sort((final a, final b) => b.cost.compareTo(a.cost));
        break;
      case BudgetSortOption.amountLowest:
        sortedItems.sort((final a, final b) => a.cost.compareTo(b.cost));
        break;
      case BudgetSortOption.typeAZ:
        sortedItems.sort(
          (final a, final b) =>
              a.budgetType.toLowerCase().compareTo(b.budgetType.toLowerCase()),
        );
        break;
    }

    return sortedItems;
  }
}
