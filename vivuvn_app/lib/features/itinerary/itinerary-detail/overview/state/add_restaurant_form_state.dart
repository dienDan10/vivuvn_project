import '../models/location.dart';

/// State for add/edit restaurant form
class AddRestaurantFormState {
  final Location? selectedLocation;
  final DateTime? mealDate;

  const AddRestaurantFormState({
    this.selectedLocation,
    this.mealDate,
  });

  AddRestaurantFormState copyWith({
    Location? selectedLocation,
    DateTime? mealDate,
  }) {
    return AddRestaurantFormState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      mealDate: mealDate ?? this.mealDate,
    );
  }

  bool get isValid => selectedLocation != null;
}
