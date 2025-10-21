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

  const BudgetState({
    this.isLoading = false,
    this.error,
    this.itineraryId,
    this.budget,
    this.items = const [],
    this.types = const [],
  });

  /// Create a copy with updated fields
  BudgetState copyWith({
    final bool? isLoading,
    final String? error,
    final int? itineraryId,
    final Budget? budget,
    final List<BudgetItem>? items,
    final List<BudgetType>? types,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
      budget: budget ?? this.budget,
      items: items ?? this.items,
      types: types ?? this.types,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is BudgetState &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.itineraryId == itineraryId &&
        other.budget == budget &&
        _listEquals(other.items, items) &&
        _listEquals(other.types, types);
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        itineraryId.hashCode ^
        budget.hashCode ^
        items.hashCode ^
        types.hashCode;
  }

  @override
  String toString() {
    return 'BudgetState(isLoading: $isLoading, error: $error, itineraryId: $itineraryId, itemsCount: ${items.length}, typesCount: ${types.length})';
  }

  /// Helper to compare lists
  bool _listEquals<T>(final List<T> a, final List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
