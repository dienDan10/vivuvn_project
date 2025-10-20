import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dto/add_budget_item_request.dart';
import '../dto/delete_budget_item_request.dart';
import '../dto/update_budget_item_request.dart';
import '../dto/update_budget_request.dart';
import '../models/budget.dart';
import '../models/budget_items.dart';
import '../models/budget_type.dart';

final budgetApiProvider = Provider.autoDispose<BudgetApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return BudgetApi(dio);
});

class BudgetApi {
  final Dio _dio;

  BudgetApi(this._dio);

  /// Get all budget items for an itinerary
  Future<List<BudgetItem>> getBudgetItems(final int itineraryId) async {
    final budget = await getBudget(itineraryId);
    return budget.items;
  }

  /// Fetch the full Budget object for an itinerary.
  Future<Budget> getBudget(final int itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/budget');

    if (response.data == null) {
      // return an empty budget object to keep the API non-nullable
      return Budget(budgetId: 0, totalBudget: 0, estimatedBudget: 0, items: []);
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(
      response.data as Map,
    );
    return Budget.fromMap(json);
  }

  /// Create a new budget item for an itinerary
  Future<void> addBudgetItem(final AddBudgetItemRequest request) async {
    await _dio.post(
      '/api/v1/itineraries/${request.itineraryId}/budget/items',
      data: request.toJson(),
    );
  }

  /// Update an existing budget item
  Future<void> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    final int itineraryId = request.itineraryId;
    final int itemId = request.itemId;
    final data = request.toMap();

    await _dio.put(
      '/api/v1/itineraries/$itineraryId/budget/items/$itemId',
      data: data,
    );
  }

  /// Update the budget (totalBudget and/or estimatedBudget)
  Future<void> updateBudget(final UpdateBudgetRequest request) async {
    await _dio.put(
      '/api/v1/itineraries/${request.itineraryId}/budget',
      data: request.toMap(),
    );
  }

  /// Delete a budget item by id
  Future<void> deleteBudgetItem(final DeleteBudgetItemRequest request) async {
    await _dio.delete(
      '/api/v1/itineraries/${request.itineraryId}/budget/items/${request.itemId}',
    );
  }

  /// Get available budget types of an itinerary
  Future<List<BudgetType>> getBudgetTypes(final int itineraryId) async {
    final response = await _dio.get(
      '/api/v1/itineraries/$itineraryId/budget/budget-types',
    );

    if (response.data == null) return [];

    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map(
          (final e) => BudgetType.fromMap(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }
}
