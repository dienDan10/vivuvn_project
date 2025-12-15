import '../data/dto/add_budget_item_request.dart';
import '../data/dto/delete_budget_item_request.dart';
import '../data/dto/update_budget_item_request.dart';
import '../data/dto/update_budget_request.dart';
import '../data/models/budget.dart';
import '../data/models/budget_items.dart';
import '../data/models/budget_type.dart';

abstract interface class IBudgetService {
  /// Fetch the full budget for an itinerary.
  Future<Budget> getBudget(final int itineraryId);

  /// Fetch only the budget items for an itinerary.
  Future<List<BudgetItem>> getBudgetItems(final int itineraryId);

  /// Add a budget item.
  /// Returns: BudgetItem vừa được tạo từ server.
  Future<BudgetItem> addBudgetItem(final AddBudgetItemRequest request);

  /// Update a budget item.
  Future<void> updateBudgetItem(final UpdateBudgetItemRequest request);

  /// Update the budget (totalBudget and/or estimatedBudget).
  Future<void> updateBudget(final UpdateBudgetRequest request);

  /// Delete a budget item.
  Future<void> deleteBudgetItem(final DeleteBudgetItemRequest request);

  /// Get available budget types for an itinerary.
  Future<List<BudgetType>> getBudgetTypes(final int itineraryId);
}
