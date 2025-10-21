import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/budget_api.dart';
import '../data/dto/add_budget_item_request.dart';
import '../data/dto/delete_budget_item_request.dart';
import '../data/dto/update_budget_item_request.dart';
import '../data/dto/update_budget_request.dart';
import '../data/models/budget.dart';
import '../data/models/budget_items.dart';
import '../data/models/budget_type.dart';
import 'ibudget_service.dart';

final budgetServiceProvider = Provider.autoDispose<IBudgetService>((final ref) {
  final budgetApi = ref.watch(budgetApiProvider);
  return BudgetService(budgetApi);
});

/// Service layer cho budget feature
///
/// Xử lý business logic và gọi API thông qua BudgetApi.
/// Không xử lý state management (do Controller đảm nhận).
class BudgetService implements IBudgetService {
  final BudgetApi _budgetApi;

  const BudgetService(this._budgetApi);

  @override
  Future<Budget> getBudget(final int itineraryId) async {
    return await _budgetApi.getBudget(itineraryId);
  }

  @override
  Future<List<BudgetItem>> getBudgetItems(final int itineraryId) async {
    return await _budgetApi.getBudgetItems(itineraryId);
  }

  @override
  Future<void> addBudgetItem(final AddBudgetItemRequest request) async {
    return await _budgetApi.addBudgetItem(request);
  }

  @override
  Future<void> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    return await _budgetApi.updateBudgetItem(request);
  }

  @override
  Future<void> updateBudget(final UpdateBudgetRequest request) async {
    return await _budgetApi.updateBudget(request);
  }

  @override
  Future<void> deleteBudgetItem(final DeleteBudgetItemRequest request) async {
    return await _budgetApi.deleteBudgetItem(request);
  }

  @override
  Future<List<BudgetType>> getBudgetTypes(final int itineraryId) async {
    return await _budgetApi.getBudgetTypes(itineraryId);
  }
}
