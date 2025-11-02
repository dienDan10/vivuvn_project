import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../../../../../common/validator/validator.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../../view-itinerary-list/models/itinerary.dart';
import '../service/itinerary_detail_service.dart';
import '../state/itinerary_detail_state.dart';

final itineraryDetailControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryDetailController,
      ItineraryDetailState
    >(() => ItineraryDetailController());

class ItineraryDetailController
    extends AutoDisposeNotifier<ItineraryDetailState> {
  @override
  ItineraryDetailState build() => ItineraryDetailState();

  /// Lưu ID và fetch detail
  void setItineraryId(final int id) async {
    state = state.copyWith(itineraryId: id);
  }

  /// Fetch itinerary detail by ID
  Future<void> fetchItineraryDetail() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await ref
          .read(itineraryDetailServiceProvider)
          .getItineraryDetail(state.itineraryId!);
      state = state.copyWith(itinerary: data);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
    } catch (e) {
      state = state.copyWith(error: 'unknown error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Update group size locally to avoid reloading the whole screen
  void setGroupSize(final int newGroupSize) {
    final current = state.itinerary;
    if (current == null) return;
    final updated = Itinerary(
      id: current.id,
      name: current.name,
      imageUrl: current.imageUrl,
      startDate: current.startDate,
      endDate: current.endDate,
      groupSize: newGroupSize,
      destinationProvinceName: current.destinationProvinceName,
      transportationVehicle: current.transportationVehicle,
    );
    state = state.copyWith(itinerary: updated);
  }

  // Group size inline editing flow
  void startGroupSizeEditing() {
    final draft = state.itinerary?.groupSize;
    state = state.copyWith(isGroupSizeEditing: true, groupSizeDraft: draft);
  }

  void cancelGroupSizeEditing() {
    state = state.copyWith(
      isGroupSizeEditing: false,
      isGroupSizeSaving: false,
      groupSizeDraft: null,
    );
  }

  void updateGroupSizeDraft(final int? value) {
    state = state.copyWith(groupSizeDraft: value);
  }

  Future<bool> saveGroupSize(final BuildContext context) async {
    final itineraryId = state.itineraryId;
    final draft = state.groupSizeDraft;
    if (itineraryId == null) return false;
    // Validate (treat null or empty as invalid)
    final validationError = Validator.validateGroupSize(
      draft?.toString(),
    );
    if (validationError != null) {
      if (context.mounted) {
        GlobalToast.showErrorToast(context, message: validationError);
      }
      return false;
    }
    // At this point draft must be non-null
    if (draft == null) return false;
    state = state.copyWith(isGroupSizeSaving: true, error: null);
    try {
      await ref
          .read(itineraryDetailServiceProvider)
          .updateGroupSize(itineraryId: itineraryId, groupSize: draft);
      setGroupSize(draft);
      state = state.copyWith(
        isGroupSizeEditing: false,
        isGroupSizeSaving: false,
        groupSizeDraft: null,
      );
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(isGroupSizeSaving: false, error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(isGroupSizeSaving: false, error: 'unknown error');
      return false;
    }
  }
}
