import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../../../../../common/validator/validator.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../../../home/controller/home_controller.dart';
import '../../../update-itinerary/controller/update_itinerary_controller.dart';
import '../../../view-itinerary-list/controller/itinerary_controller.dart';
import '../../../view-itinerary-list/models/itinerary.dart';
import '../../schedule/model/transportation_mode.dart';
import '../service/itinerary_detail_service.dart';
import '../service/qr_code_save_service.dart';
import '../state/itinerary_detail_state.dart';

final itineraryDetailControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryDetailController,
      ItineraryDetailState
    >(() => ItineraryDetailController());

/// Provider to check if current user is the owner of the itinerary
final isItineraryOwnerProvider = Provider.autoDispose<bool>((final ref) {
  return ref.watch(
    itineraryDetailControllerProvider.select(
      (final state) => state.itinerary?.isOwner ?? false,
    ),
  );
});

class ItineraryDetailController
    extends AutoDisposeNotifier<ItineraryDetailState> {
  @override
  ItineraryDetailState build() => ItineraryDetailState();

  /// Lưu ID và fetch detail
  void setItineraryId(final int id) async {
    // If setting the same ID and itinerary is already loaded, skip
    if (state.itineraryId == id && 
        state.itinerary != null && 
        state.itinerary!.id == id) {
      return;
    }
    
    // If itinerary is already set and matches the ID, just update itineraryId without clearing itinerary
    if (state.itinerary != null && state.itinerary!.id == id) {
      state = state.copyWith(itineraryId: id);
      return;
    }
    
    // Just set itineraryId, don't clear existing itinerary data
    // The listener will check if itinerary matches the ID before fetching
    state = state.copyWith(itineraryId: id);
  }

  /// Set itinerary data directly (used when data is already fetched, e.g., from ItineraryCard)
  void setItineraryData(final Itinerary itinerary) {
    // Set both itineraryId and itinerary data to avoid duplicate fetch
    state = state.copyWith(
      itineraryId: itinerary.id,
      itinerary: itinerary,
      inviteCode: itinerary.inviteCode ?? state.inviteCode,
      isLoading: false,
    );
  }

  // Track the ongoing fetch Future to prevent duplicate calls
  Future<void>? _ongoingFetch;
  // Track the itineraryId that is currently being fetched
  int? _fetchingItineraryId;

  /// Fetch itinerary detail by ID.
  ///
  /// - [force]: bỏ qua cache nếu `true`, luôn gọi API.
  /// - [showLoading]: nếu `false` sẽ refresh ngầm, không bật trạng thái loading toàn màn.
  Future<void> fetchItineraryDetail({
    final bool force = false,
    final bool showLoading = true,
  }) async {
    // If itinerary is already loaded and matches current ID, skip fetch unless forced
    if (!force &&
        state.itinerary != null && 
        state.itinerary!.id == state.itineraryId) {
      return;
    }
    
    final currentItineraryId = state.itineraryId;
    if (currentItineraryId == null) {
      return;
    }
    
    // If we're already fetching this specific itineraryId, return the ongoing fetch
    if (_fetchingItineraryId == currentItineraryId && _ongoingFetch != null) {
      return _ongoingFetch!;
    }
    
    // Prevent duplicate fetches if already loading
    if (state.isLoading) {
      return;
    }
    // Create and store the fetch Future immediately to prevent race conditions
    // Use a Completer to ensure we can return the same Future for concurrent calls
    final completer = Completer<void>();
    _fetchingItineraryId = currentItineraryId;
    _ongoingFetch = completer.future;
    state = state.copyWith(
      isLoading: showLoading ? true : state.isLoading,
      error: null,
    );
    
    // Perform the actual fetch
    try {
      final data = await ref
          .read(itineraryDetailServiceProvider)
          .getItineraryDetail(currentItineraryId);
      // Sync inviteCode từ itinerary object vào state nếu có
      state = state.copyWith(
        itinerary: data,
        inviteCode: data.inviteCode ?? state.inviteCode,
        isLoading: showLoading ? false : state.isLoading,
      );
      completer.complete();
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        isLoading: showLoading ? false : state.isLoading,
      );
      completer.completeError(e);
    } catch (e) {
      state = state.copyWith(
        error: 'unknown error',
        isLoading: showLoading ? false : state.isLoading,
      );
      completer.completeError(e);
    } finally {
      // Clear the ongoing fetch only if it's still the current one
      if (_fetchingItineraryId == currentItineraryId) {
        _ongoingFetch = null;
        _fetchingItineraryId = null;
      }
    }
  }

  /// Update group size locally to avoid reloading the whole screen
  void setGroupSize(final int newGroupSize) {
    final current = state.itinerary;
    if (current == null) return;
    state = state.copyWith(
      itinerary: current.copyWith(groupSize: newGroupSize),
    );
  }

  // Transportation draft management (UI state only)
  void setTransportationVehicleDraft(final String? vehicle) {
    if (vehicle == null) {
      state = state.copyWith(transportationVehicleDraft: null);
      return;
    }
    final normalized = TransportationMode.normalizeLabel(vehicle);
    state = state.copyWith(transportationVehicleDraft: normalized);
  }

  void startTransportationSelection() {
    final current = state.itinerary?.transportationVehicle;
    if (current == null || current.isEmpty) {
      state = state.copyWith(transportationVehicleDraft: null);
      return;
    }
    final normalized = TransportationMode.normalizeLabel(current);
    state = state.copyWith(transportationVehicleDraft: normalized);
  }

  void clearTransportationVehicleDraft() {
    state = state.copyWith(transportationVehicleDraft: null);
  }

  Future<void> saveTransportationVehicle(
    final BuildContext context,
    final String vehicle,
  ) async {
    final itineraryId = state.itineraryId;
    final itinerary = state.itinerary;
    if (itineraryId == null || itinerary == null) return;

    final normalized = TransportationMode.normalizeLabel(vehicle);
    final apiTransportation = TransportationMode.toApiValue(normalized);
    final previousVehicle = itinerary.transportationVehicle;

    state = state.copyWith(
      isTransportationSaving: true,
      transportationVehicleDraft: normalized,
      error: null,
    );

    try {
      await ref
          .read(itineraryDetailServiceProvider)
          .updateTransportation(
            itineraryId: itineraryId,
            transportation: apiTransportation,
          );

      final updatedItinerary = itinerary.copyWith(
        transportationVehicle: normalized,
      );

      state = state.copyWith(
        itinerary: updatedItinerary,
        transportationVehicleDraft: null,
        isTransportationSaving: false,
      );

      if (context.mounted) {
        GlobalToast.showSuccessToast(
          context,
          message: 'Cập nhật phương tiện thành công',
        );
      }
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        isTransportationSaving: false,
        transportationVehicleDraft: null,
        itinerary: itinerary.copyWith(transportationVehicle: previousVehicle),
        error: errorMsg,
      );
      if (context.mounted) {
        GlobalToast.showErrorToast(context, message: errorMsg);
      }
    } catch (_) {
      state = state.copyWith(
        isTransportationSaving: false,
        transportationVehicleDraft: null,
        itinerary: itinerary.copyWith(transportationVehicle: previousVehicle),
        error: 'unknown error',
      );
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          message: 'Đã xảy ra lỗi, vui lòng thử lại',
        );
      }
    }
  }

  /// Update itinerary name locally to reflect immediately after saving
  void setName(final String newName) {
    final current = state.itinerary;
    if (current == null) return;
    state = state.copyWith(itinerary: current.copyWith(name: newName));
  }

  /// Update itinerary privacy status locally to reflect immediately after saving
  void setPublicStatus(final bool isPublic) {
    final current = state.itinerary;
    if (current == null) return;
    state = state.copyWith(itinerary: current.copyWith(isPublic: isPublic));
  }

  /// Update privacy status with API call and feedback
  /// Updates UI optimistically first, then sends request
  Future<void> updatePrivacyStatus(
    final BuildContext context,
    final bool isPublic,
  ) async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return;

    // Save old state to revert if request fails
    final oldIsPublic = state.itinerary?.isPublic ?? false;

    // Update UI immediately (optimistic update)
    setPublicStatus(isPublic);

    final updater = ref.read(updateItineraryControllerProvider.notifier);
    updater.setItineraryId(itineraryId);

    // Send request without fetching (already updated local state)
    final ok = isPublic
        ? await updater.setPublic(shouldFetch: false)
        : await updater.setPrivate(shouldFetch: false);

    // Fetch list in background to sync data for list screen
    if (ok) {
      ref.read(itineraryControllerProvider.notifier).fetchItineraries();
    }

    if (!ok) {
      // Revert UI if request failed
      setPublicStatus(oldIsPublic);
      if (context.mounted) {
        final errorMsg =
            ref.read(updateItineraryControllerProvider).error ??
            'Cập nhật trạng thái thất bại';
        GlobalToast.showErrorToast(context, message: errorMsg);
      }
    }
  }

  // Name inline editing flow
  void startNameEditing() {
    final currentName = state.itinerary?.name;
    state = state.copyWith(
      isNameEditing: true,
      isNameSaving: false,
      nameDraft: currentName,
    );
  }

  void cancelNameEditing() {
    state = state.copyWith(
      isNameEditing: false,
      isNameSaving: false,
      nameDraft: null,
    );
  }

  void updateNameDraft(final String value) {
    state = state.copyWith(nameDraft: value);
  }

  Future<void> saveName(final BuildContext context) async {
    final itineraryId = state.itineraryId;
    final draft = state.nameDraft?.trim() ?? '';
    final isOwner = state.itinerary?.isOwner ?? false;
    if (!isOwner) {
      cancelNameEditing();
      return;
    }
    if (itineraryId == null) {
      cancelNameEditing();
      return;
    }

    // Delegate validation + API + toast to update controller
    final updater = ref.read(updateItineraryControllerProvider.notifier);
    updater.setItineraryId(itineraryId);

    state = state.copyWith(isNameSaving: true);
    final ok = await updater.updateNameWithFeedback(context, draft);
    if (ok) {
      setName(draft);
      cancelNameEditing();
    } else {
      state = state.copyWith(isNameSaving: false);
    }
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
    final validationError = Validator.validateGroupSize(draft?.toString());
    if (validationError != null) {
      if (!context.mounted) return false;
      GlobalToast.showErrorToast(context, message: validationError);
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
      // Refresh home data to update "recent itineraries" section
      ref.read(homeControllerProvider.notifier).refreshHomeDataSilently();
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

  /// Fetch invite code for the itinerary
  Future<void> fetchInviteCode() async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return;

    state = state.copyWith(isInviteCodeLoading: true, inviteCodeError: null);

    try {
      final inviteCode = await ref
          .read(itineraryDetailServiceProvider)
          .getInviteCode(itineraryId);
      state = state.copyWith(
        inviteCode: inviteCode,
        isInviteCodeLoading: false,
        inviteCodeError: null,
      );
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        isInviteCodeLoading: false,
        inviteCodeError: errorMsg,
      );
    } catch (e) {
      state = state.copyWith(
        isInviteCodeLoading: false,
        inviteCodeError: 'unknown error',
      );
    }
  }

  /// Save QR code to Gallery
  Future<void> saveQrCodeToGallery(
    final BuildContext context,
    final GlobalKey repaintBoundaryKey,
  ) async {
    final inviteCode = state.inviteCode ?? state.itinerary?.inviteCode;

    if (inviteCode == null) {
      if (!context.mounted) return;
      GlobalToast.showErrorToast(
        context,
        message: 'Không có mã QR code để lưu',
      );
      return;
    }

    state = state.copyWith(isSavingQrCode: true);

    try {
      final qrCodeSaveService = ref.read(qrCodeSaveServiceProvider);
      await qrCodeSaveService.saveQrCodeToGallery(context, repaintBoundaryKey);
    } catch (e) {
      // Error handling đã được xử lý trong service
      // Chỉ cần log nếu cần thiết
    } finally {
      state = state.copyWith(isSavingQrCode: false);
    }
  }

  /// Delete itinerary with confirmation modal
  Future<void> deleteItinerary(final BuildContext context) async {
    final itineraryId = state.itineraryId;
    if (itineraryId == null) return;

    // Get the detail screen context before closing modal
    // The context in modal builder is from detail screen (parent)
    final detailScreenContext = Navigator.of(
      context,
      rootNavigator: false,
    ).context;
    if (!detailScreenContext.mounted) return;

    // Close settings modal first
    Navigator.of(context).pop();

    // Wait a bit for modal to close, then show confirmation dialog
    await Future.delayed(const Duration(milliseconds: 100));

    // Check if context is still mounted after pop
    if (!detailScreenContext.mounted) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: detailScreenContext,
      builder: (final dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa hành trình này? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    // If confirmed, delete and navigate back to list
    if (confirmed == true && detailScreenContext.mounted) {
      // Delete itinerary using itinerary controller
      try {
        await ref
            .read(itineraryControllerProvider.notifier)
            .deleteItinerary(itineraryId);

        // Navigate back to itinerary list after successful deletion
        if (detailScreenContext.mounted) {
          Navigator.of(detailScreenContext).pop();
        }
      } catch (e) {
        // Error is already handled in itinerary controller state
        // Show error toast if needed
        if (detailScreenContext.mounted) {
          final errorState = ref.read(itineraryControllerProvider).error;
          if (errorState != null) {
            GlobalToast.showErrorToast(
              detailScreenContext,
              message: errorState,
            );
          }
        }
      }
    }
  }
}
