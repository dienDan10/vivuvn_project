import '../data/models/budget.dart';
import '../data/models/budget_items.dart';
import '../data/models/budget_type.dart';

class BudgetState {
  final bool isLoading;
  final String? error;
  final int? itineraryId;
  final Budget? budget;
  final List<BudgetItem> items;
  final List<BudgetType> types;

  BudgetState({
    this.isLoading = false,
    this.error,
    this.itineraryId,
    this.budget,
    this.items = const [],
    this.types = const [],
  });

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
      error: error ?? this.error,
      itineraryId: itineraryId ?? this.itineraryId,
      budget: budget ?? this.budget,
      items: items ?? this.items,
      types: types ?? this.types,
    );
  }
}
