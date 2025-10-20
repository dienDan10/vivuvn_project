import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/validator/validation_exception.dart';
import '../../../../../common/validator/validator.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dto/add_budget_item_request.dart';
import '../data/dto/delete_budget_item_request.dart';
import '../data/dto/update_budget_item_request.dart';
import '../data/dto/update_budget_request.dart';
import '../services/budget_service.dart';
import '../state/budget_state.dart';

final budgetControllerProvider =
    AutoDisposeNotifierProvider<BudgetController, BudgetState>(
      () => BudgetController(),
    );

class BudgetController extends AutoDisposeNotifier<BudgetState> {
  @override
  BudgetState build() {
    return BudgetState();
  }

  /// Load budget (and items) by itineraryId
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

  Future<bool> addBudgetItem(final AddBudgetItemRequest request) async {
    try {
      final service = ref.read(budgetServiceProvider);

      // validate and throw ValidationException on error
      _validateBudgetItemForAdd(request);

      await service.addBudgetItem(request);

      // reload
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

  Future<bool> updateBudgetItem(final UpdateBudgetItemRequest request) async {
    try {
      // validate using the helper
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

  Future<bool> updateBudget(final UpdateBudgetRequest request) async {
    try {
      // validate estimatedBudget
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
