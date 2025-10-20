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

class BudgetService implements IBudgetService {
  final BudgetApi _budgetApi;
  BudgetService(this._budgetApi);

  @override
  Future<Budget> getBudget(final int itineraryId) async {
    try {
      return await _budgetApi.getBudget(itineraryId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BudgetItem>> getBudgetItems(final int itineraryId) async {
    try {
      return await _budgetApi.getBudgetItems(itineraryId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBudgetItem(final AddBudgetItemRequest request) async {
    try {
      return await _budgetApi.addBudgetItem(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    try {
      return await _budgetApi.updateBudgetItem(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBudget(final UpdateBudgetRequest request) async {
    try {
      return await _budgetApi.updateBudget(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteBudgetItem(final DeleteBudgetItemRequest request) async {
    try {
      return await _budgetApi.deleteBudgetItem(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BudgetType>> getBudgetTypes(final int itineraryId) async {
    try {
      return await _budgetApi.getBudgetTypes(itineraryId);
    } catch (e) {
      rethrow;
    }
  }
}
