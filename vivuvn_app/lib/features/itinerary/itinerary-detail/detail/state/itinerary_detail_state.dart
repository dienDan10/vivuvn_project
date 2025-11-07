import '../../../view-itinerary-list/models/itinerary.dart';

// Sentinel to allow copyWith to distinguish between "not provided" and "explicit null"
const Object _noValue = Object();

class ItineraryDetailState {
  final int? itineraryId;
  final bool isLoading;
  final Itinerary? itinerary;
  final String? error;
  // Group size inline edit state
  final bool isGroupSizeEditing;
  final bool isGroupSizeSaving;
  final int? groupSizeDraft;
  // Name inline edit state
  final bool isNameEditing;
  final bool isNameSaving;
  final String? nameDraft;
  // Invite code state
  final String? inviteCode;
  final bool isInviteCodeLoading;
  final String? inviteCodeError;
  // QR code save state
  final bool isSavingQrCode;
  // Transportation selection draft (UI-only until saved)
  final String? transportationVehicleDraft;

  ItineraryDetailState({
    this.itineraryId,
    this.isLoading = false,
    this.itinerary,
    this.error,
    this.isGroupSizeEditing = false,
    this.isGroupSizeSaving = false,
    this.groupSizeDraft,
    this.isNameEditing = false,
    this.isNameSaving = false,
    this.nameDraft,
    this.inviteCode,
    this.isInviteCodeLoading = false,
    this.inviteCodeError,
    this.isSavingQrCode = false,
    this.transportationVehicleDraft,
  });

  ItineraryDetailState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final Itinerary? itinerary,
    final String? error,
    final bool? isGroupSizeEditing,
    final bool? isGroupSizeSaving,
    final Object? groupSizeDraft = _noValue,
    final bool? isNameEditing,
    final bool? isNameSaving,
    final Object? nameDraft = _noValue,
    final String? inviteCode,
    final bool? isInviteCodeLoading,
    final Object? inviteCodeError = _noValue,
    final bool? isSavingQrCode,
    final Object? transportationVehicleDraft = _noValue,
  }) {
    return ItineraryDetailState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      itinerary: itinerary ?? this.itinerary,
      error: error,
      isGroupSizeEditing: isGroupSizeEditing ?? this.isGroupSizeEditing,
      isGroupSizeSaving: isGroupSizeSaving ?? this.isGroupSizeSaving,
      groupSizeDraft: identical(groupSizeDraft, _noValue)
          ? this.groupSizeDraft
          : groupSizeDraft as int?,
      isNameEditing: isNameEditing ?? this.isNameEditing,
      isNameSaving: isNameSaving ?? this.isNameSaving,
      nameDraft:
          identical(nameDraft, _noValue) ? this.nameDraft : nameDraft as String?,
      inviteCode: inviteCode ?? this.inviteCode,
      isInviteCodeLoading: isInviteCodeLoading ?? this.isInviteCodeLoading,
      inviteCodeError: identical(inviteCodeError, _noValue)
          ? this.inviteCodeError
          : inviteCodeError as String?,
      isSavingQrCode: isSavingQrCode ?? this.isSavingQrCode,
      transportationVehicleDraft: identical(transportationVehicleDraft, _noValue)
          ? this.transportationVehicleDraft
          : transportationVehicleDraft as String?,
    );
  }
}
