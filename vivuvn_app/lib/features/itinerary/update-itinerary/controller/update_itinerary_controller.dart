import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../../../../common/validator/validator.dart';
import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../view-itinerary-list/controller/itinerary_controller.dart';
import '../service/update_itinerary_service.dart';
import '../state/update_itinerary_state.dart';

final updateItineraryControllerProvider = AutoDisposeNotifierProvider<
  UpdateItineraryController,
  UpdateItineraryState
>(() => UpdateItineraryController());

class UpdateItineraryController
    extends AutoDisposeNotifier<UpdateItineraryState> {
  @override
  UpdateItineraryState build() => UpdateItineraryState();

  void setItineraryId(final int id) {
    state = state.copyWith(itineraryId: id);
  }

  /// Validate itinerary name: non-empty, no sensitive words, max 60 chars.
  /// Returns null if valid, otherwise error message.
  String? validateName(final String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Tên hành trình không được để trống';
    if (Validator.containsSensitiveWords(trimmed)) {
      return 'Tên hành trình chứa từ cấm';
    }
    if (trimmed.length > 60) {
      return 'Tên hành trình quá dài (tối đa 60 ký tự)';
    }
    return null;
  }

  Future<bool> updateName(final String name) async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return false;
    final validationError = validateName(name);
    if (validationError != null) {
      state = state.copyWith(error: validationError);
      return false;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(updateItineraryServiceProvider)
          .updateName(itineraryId: itineraryId, name: name);
      await ref.read(itineraryControllerProvider.notifier).fetchItineraries();
      state = state.copyWith(isLoading: false, lastUpdatedName: name);
      return true;
    } on DioException catch (e) {
      final err = DioExceptionHandler.handleException(e);
      state = state.copyWith(isLoading: false, error: err);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'unknown error');
      return false;
    }
  }

  /// Validate + update + show toasts on error (controller handles logic + feedback)
  Future<bool> updateNameWithFeedback(
    final BuildContext context,
    final String name,
  ) async {
    final validationError = validateName(name);
    if (validationError != null) {
      GlobalToast.showErrorToast(context, message: validationError);
      state = state.copyWith(error: validationError);
      return false;
    }

    final ok = await updateName(name);
    if (!ok) {
      final err = state.error ?? 'Cập nhật tên thất bại';
      GlobalToast.showErrorToast(context, message: err);
    }
    return ok;
  }

  Future<bool> setPublic({final bool shouldFetch = true}) async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(updateItineraryServiceProvider)
          .setPublic(itineraryId: itineraryId);
      if (shouldFetch) {
        await ref.read(itineraryControllerProvider.notifier).fetchItineraries();
      }
      state = state.copyWith(isLoading: false, isPublic: true);
      return true;
    } on DioException catch (e) {
      final err = DioExceptionHandler.handleException(e);
      state = state.copyWith(isLoading: false, error: err);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'unknown error');
      return false;
    }
  }

  Future<bool> setPrivate({final bool shouldFetch = true}) async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(updateItineraryServiceProvider)
          .setPrivate(itineraryId: itineraryId);
      if (shouldFetch) {
        await ref.read(itineraryControllerProvider.notifier).fetchItineraries();
      }
      state = state.copyWith(isLoading: false, isPublic: false);
      return true;
    } on DioException catch (e) {
      final err = DioExceptionHandler.handleException(e);
      state = state.copyWith(isLoading: false, error: err);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'unknown error');
      return false;
    }
  }

  /// Update privacy status with optimistic update
  /// Updates UI immediately, then sends request (without fetching list)
  Future<void> updatePrivacyStatusWithOptimistic(
    final BuildContext context,
    final int itineraryId,
    final bool isPublic,
    final bool currentIsPublic,
  ) async {
    // Save old state for revert
    final oldIsPublic = currentIsPublic;

    // Update optimistic state immediately
    final updatedMap = Map<int, bool>.from(state.optimisticIsPublicMap);
    updatedMap[itineraryId] = isPublic;
    state = state.copyWith(
      optimisticIsPublicMap: updatedMap,
      isLoading: true,
      error: null,
    );

    setItineraryId(itineraryId);

    // Send request without fetching itineraries (to avoid reload)
    final ok = isPublic 
        ? await setPublic(shouldFetch: false) 
        : await setPrivate(shouldFetch: false);

    if (!ok) {
      // Revert optimistic state if request failed
      final revertedMap = Map<int, bool>.from(state.optimisticIsPublicMap);
      revertedMap[itineraryId] = oldIsPublic;
      state = state.copyWith(
        optimisticIsPublicMap: revertedMap,
        isLoading: false,
      );
      
      if (context.mounted) {
        final errorMsg = state.error ?? 'Cập nhật trạng thái thất bại';
        GlobalToast.showErrorToast(context, message: errorMsg);
      }
    } else {
      // Keep optimistic state, fetch list in background without blocking UI
      state = state.copyWith(isLoading: false);
      // Fetch in background to sync data, but don't wait
      // Optimistic state will be cleared when itinerary.isPublic matches the optimistic value
      // This is handled in the UI by checking if values match
      ref.read(itineraryControllerProvider.notifier).fetchItineraries();
    }
  }

  /// Clear optimistic state for a specific itinerary
  void clearOptimisticState(final int itineraryId) {
    final currentMap = state.optimisticIsPublicMap;
    if (currentMap.containsKey(itineraryId)) {
      final clearedMap = Map<int, bool>.from(currentMap);
      clearedMap.remove(itineraryId);
      state = state.copyWith(optimisticIsPublicMap: clearedMap);
    }
  }
}


