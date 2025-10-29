import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/validator/validation_exception.dart';
import '../../../../../common/validator/validator.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dto/add_budget_item_request.dart';
import '../data/dto/delete_budget_item_request.dart';
import '../data/dto/update_budget_item_request.dart';
import '../data/dto/update_budget_request.dart';
import '../data/enums/budget_sort_option.dart';
import '../data/models/budget_items.dart';
import '../services/budget_service.dart';
import '../state/budget_state.dart';

final budgetControllerProvider =
    AutoDisposeNotifierProvider<BudgetController, BudgetState>(
      () => BudgetController(),
    );

/// Controller quản lý state và business logic cho budget feature
///
/// Cung cấp các operations:
/// - Load budget và danh sách chi tiêu
/// - Add/Update/Delete budget items
/// - Update estimated budget
/// - Load budget types
/// - Validation cho tất cả operations
class BudgetController extends AutoDisposeNotifier<BudgetState> {
  @override
  BudgetState build() {
    return const BudgetState();
  }

  /// Load budget và danh sách chi tiêu theo itineraryId
  ///
  /// Set loading state trước khi gọi API và update state sau khi hoàn thành.
  /// Handle errors và set error message vào state.
  Future<void> loadBudget(final int? itineraryId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      itineraryId: itineraryId,
    );

    try {
      final service = ref.read(budgetServiceProvider);
      final budget = await service.getBudget(itineraryId!);
      state = state.copyWith(
        budget: budget,
        items: budget.items,
        isLoading: false,
      );
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Unknown error', isLoading: false);
    }
  }

  void sortBudgetItem(final BudgetSortOption option) {
    final sortedItems = List<BudgetItem>.from(state.items);

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

    state = state.copyWith(items: sortedItems, currentSort: option);
  }

  /// Thêm budget item mới
  ///
  /// Validate request trước khi gọi API.
  /// Reload budget sau khi thêm thành công.
  ///
  /// Returns: true nếu thành công, false nếu có lỗi
  Future<bool> addBudgetItem(final AddBudgetItemRequest request) async {
    try {
      final service = ref.read(budgetServiceProvider);

      _validateBudgetItemForAdd(request);

      await service.addBudgetItem(request);
      await loadBudget(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } on ValidationException catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Update budget item
  ///
  /// Validate request và ít nhất 1 field phải được update.
  /// Reload budget sau khi update thành công.
  ///
  /// Returns: true nếu thành công, false nếu có lỗi
  Future<bool> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    try {
      _validateUpdateRequest(request);

      final service = ref.read(budgetServiceProvider);
      await service.updateBudgetItem(request);

      await loadBudget(state.itineraryId);
      return true;
    } on ValidationException catch (e) {
      // validation error
      state = state.copyWith(error: e.toString());
      return false;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Xóa budget item
  ///
  /// Reload budget sau khi xóa thành công.
  ///
  /// Returns: true nếu thành công, false nếu có lỗi
  Future<bool> deleteBudgetItem(final DeleteBudgetItemRequest request) async {
    try {
      final service = ref.read(budgetServiceProvider);
      await service.deleteBudgetItem(request);

      await loadBudget(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Update estimated budget
  ///
  /// Validate estimated budget phải >= 0.
  /// Reload budget sau khi update thành công.
  ///
  /// Returns: true nếu thành công, false nếu có lỗi
  Future<bool> updateBudget(final UpdateBudgetRequest request) async {
    try {
      _validateEstimatedBudget(request.estimatedBudget);

      final service = ref.read(budgetServiceProvider);
      await service.updateBudget(request);

      await loadBudget(state.itineraryId);

      return true;
    } on ValidationException catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Load danh sách budget types
  ///
  /// Gọi API để lấy tất cả budget types cho itinerary.
  /// Update vào state.types để sử dụng trong type picker.
  Future<void> loadBudgetTypes(final int itineraryId) async {
    try {
      final service = ref.read(budgetServiceProvider);
      final types = await service.getBudgetTypes(itineraryId);
      state = state.copyWith(types: types);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
    }
  }

  /// Tìm budget type ID theo tên
  ///
  /// Sử dụng khi API không trả về budgetTypeObj.
  ///
  /// Returns: budgetTypeId nếu tìm thấy, null nếu không tìm thấy
  int? getBudgetTypeIdByName(final String typeName) {
    if (state.types.isEmpty) return null;

    try {
      final matchingType = state.types.firstWhere(
        (final type) => type.name == typeName,
      );
      return matchingType.budgetTypeId;
    } catch (e) {
      // If no match found, return null
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Validation helpers
  void _validateBudgetItemForAdd(final AddBudgetItemRequest request) {
    _validateBudgetFields(
      name: request.name,
      cost: request.cost,
      budgetTypeId: request.budgetTypeId,
    );
  }

  void _validateUpdateRequest(final UpdateBudgetItemRequest request) {
    // Update requires at least one field
    if (request.name == null &&
        request.cost == null &&
        request.budgetTypeId == null &&
        request.budgetType == null &&
        request.date == null) {
      throw ValidationException(
        'Phải cung cấp ít nhất một trường để cập nhật (tên, chi phí, loại ngân sách, ngày)',
      );
    }

    _validateBudgetFields(
      name: request.name,
      cost: request.cost,
      budgetTypeId: request.budgetTypeId,
    );
  }

  /// Common validation for budget item fields (used by both add and update)
  void _validateBudgetFields({
    required final String? name,
    required final double? cost,
    required final int? budgetTypeId,
  }) {
    if (name != null) {
      if (name.trim().isEmpty) {
        throw ValidationException('Tên không được để trống');
      }
      if (Validator.containsSensitiveWords(name)) {
        throw ValidationException('Tên chứa từ ngữ không được phép');
      }
    }

    if (cost != null && (cost.isNaN || cost < 0)) {
      throw ValidationException('Số tiền phải lớn hơn hoặc bằng 0');
    }
  }

  void _validateEstimatedBudget(final double estimatedBudget) {
    if (estimatedBudget.isNaN || estimatedBudget < 0) {
      throw ValidationException('Ngân sách dự kiến phải lớn hơn hoặc bằng 0');
    }
  }
}
