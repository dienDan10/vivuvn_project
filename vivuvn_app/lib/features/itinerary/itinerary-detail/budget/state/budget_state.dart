import '../data/enums/budget_sort_option.dart';
import '../data/models/budget.dart';
import '../data/models/budget_items.dart';
import '../data/models/budget_type.dart';

/// State class cho budget feature
///
/// Quản lý:
/// - Loading state và error messages
/// - Budget data (totalBudget, estimatedBudget)
/// - Danh sách budget items
/// - Danh sách budget types
class BudgetState {
  final bool isLoading;
  final String? error;
  final int? itineraryId;
  final Budget? budget;
  final List<BudgetItem> items;
  final List<BudgetType> types;
  final BudgetSortOption currentSort;

  const BudgetState({
    this.isLoading = false,
    this.error,
    this.itineraryId,
    this.budget,
    this.items = const [],
    this.types = const [],
    this.currentSort = BudgetSortOption.dateNewest,
  });

  /// Create a copy with updated fields
  BudgetState copyWith({
    final bool? isLoading,
    final String? error,
    final int? itineraryId,
    final Budget? budget,
    final List<BudgetItem>? items,
    final List<BudgetType>? types,
    final BudgetSortOption? currentSort,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
      budget: budget ?? this.budget,
      items: items ?? this.items,
      types: types ?? this.types,
      currentSort: currentSort ?? this.currentSort,
    );
  }
}
