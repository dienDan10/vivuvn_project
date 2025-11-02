import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/hotel.dart';

class NearbyHotelState {
  final bool isLoading;
  final String? errorMessage;
  final List<Hotel> hotels;
  final List<Marker> markers;
  final int currentHotelIndex;

  NearbyHotelState({
    this.isLoading = false,
    this.errorMessage,
    this.hotels = const [],
    this.markers = const [],
    this.currentHotelIndex = 0,
  });

  NearbyHotelState copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final List<Hotel>? hotels,
    final List<Marker>? markers,
    final int? currentHotelIndex,
  }) {
    return NearbyHotelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hotels: hotels ?? this.hotels,
      markers: markers ?? this.markers,
      currentHotelIndex: currentHotelIndex ?? this.currentHotelIndex,
    );
  }
}
