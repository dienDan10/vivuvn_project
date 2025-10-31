import '../data/dto/restaurant_item_response.dart';
import '../models/location.dart';

class _UnsetR {
  const _UnsetR();
}

class RestaurantsState {
  final bool isLoading;
  final List<RestaurantItemResponse> restaurants;
  final String? error;
  final int? itineraryId;
  final String? savingRestaurantId;
  final RestaurantSavingType? savingType;

  // Add restaurant form fields
  final Location? formSelectedLocation;
  final DateTime? formMealDate;
  final String? formMealTime; // HH:mm:ss

  static const _UnsetR _unset = _UnsetR();

  RestaurantsState({
    this.isLoading = false,
    this.restaurants = const [],
    this.error,
    this.itineraryId,
    this.savingRestaurantId,
    this.savingType,
    this.formSelectedLocation,
    this.formMealDate,
    this.formMealTime,
  });

  RestaurantsState copyWith({
    final bool? isLoading,
    final List<RestaurantItemResponse>? restaurants,
    final String? error,
    final Object? itineraryId = _unset,
    final Object? savingRestaurantId = _unset,
    final Object? savingType = _unset,
    final Object? formSelectedLocation = _unset,
    final Object? formMealDate = _unset,
    final Object? formMealTime = _unset,
  }) {
    return RestaurantsState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      error: error,
      itineraryId:
          identical(itineraryId, _unset) ? this.itineraryId : itineraryId as int?,
      savingRestaurantId: identical(savingRestaurantId, _unset)
          ? this.savingRestaurantId
          : savingRestaurantId as String?,
      savingType: identical(savingType, _unset)
          ? this.savingType
          : savingType as RestaurantSavingType?,
      formSelectedLocation: identical(formSelectedLocation, _unset)
          ? this.formSelectedLocation
          : formSelectedLocation as Location?,
      formMealDate: identical(formMealDate, _unset)
          ? this.formMealDate
          : formMealDate as DateTime?,
      formMealTime: identical(formMealTime, _unset)
          ? this.formMealTime
          : formMealTime as String?,
    );
  }

  bool isSaving(final String restaurantId, final RestaurantSavingType type) {
    return savingRestaurantId == restaurantId && savingType == type;
  }

  bool isAnySaving(final String restaurantId) {
    return savingRestaurantId == restaurantId;
  }

  // Form helpers
  bool get formIsValid => formSelectedLocation != null;
  String get formDisplayName => formSelectedLocation?.name ?? '';
}

enum RestaurantSavingType {
  cost,
  note,
  date,
  time,
}
