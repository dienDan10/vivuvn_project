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

/// API client cho budget feature
///
/// Xử lý tất cả HTTP requests liên quan đến budget:
/// - GET: Lấy budget, budget items, budget types
/// - POST: Tạo budget item mới
/// - PUT: Cập nhật budget và budget items
/// - DELETE: Xóa budget items
class BudgetApi {
  final Dio _dio;

  const BudgetApi(this._dio);

  /// Fetch budget items cho một itinerary
  ///
  /// Returns: Danh sách budget items
  Future<List<BudgetItem>> getBudgetItems(final int itineraryId) async {
    final budget = await getBudget(itineraryId);
    return budget.items;
  }

  /// Fetch full Budget object cho một itinerary
  ///
  /// Returns: Budget với totalBudget, estimatedBudget và items
  /// Nếu không có data, return empty budget
  Future<Budget> getBudget(final int itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/budget');

    if (response.data == null) {
      // Return empty budget nếu chưa có data
      return const Budget(
        budgetId: 0,
        totalBudget: 0,
        estimatedBudget: 0,
        items: [],
      );
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(
      response.data as Map,
    );
    return Budget.fromMap(json);
  }

  /// Tạo budget item mới
  ///
  /// POST /api/v1/itineraries/{id}/budget/items
  Future<void> addBudgetItem(final AddBudgetItemRequest request) async {
    await _dio.post(
      '/api/v1/itineraries/${request.itineraryId}/budget/items',
      data: request.toJson(),
    );
  }

  /// Cập nhật budget item
  ///
  /// PUT /api/v1/itineraries/{id}/budget/items/{itemId}
  Future<void> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    final int itineraryId = request.itineraryId;
    final int itemId = request.itemId;
    final data = request.toMap();

    await _dio.put(
      '/api/v1/itineraries/$itineraryId/budget/items/$itemId',
      data: data,
    );
  }

  /// Cập nhật budget (estimatedBudget)
  ///
  /// PUT /api/v1/itineraries/{id}/budget
  Future<void> updateBudget(final UpdateBudgetRequest request) async {
    await _dio.put(
      '/api/v1/itineraries/${request.itineraryId}/budget',
      data: request.toMap(),
    );
  }

  /// Xóa budget item
  ///
  /// DELETE /api/v1/itineraries/{id}/budget/items/{itemId}
  Future<void> deleteBudgetItem(final DeleteBudgetItemRequest request) async {
    await _dio.delete(
      '/api/v1/itineraries/${request.itineraryId}/budget/items/${request.itemId}',
    );
  }

  /// Lấy danh sách budget types của một itinerary
  ///
  /// GET /api/v1/itineraries/{id}/budget/budget-types
  /// Returns: Danh sách budget types có sẵn
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
