import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../view-nearby-restaurant/service/icon_service.dart';
import '../model/hotel.dart';
import '../service/hotel_service.dart';
import '../state/nearby_hotel_state.dart';

class HotelController extends AutoDisposeNotifier<NearbyHotelState> {
  @override
  NearbyHotelState build() {
    return NearbyHotelState();
  }

  Future<void> fetchNearbyHotels(final int locationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final hotels = await ref
          .read(hotelServiceProvider)
          .fetchNearbyHotels(locationId);

      state = state.copyWith(hotels: hotels);

      await _loadHotelMarkers(hotels);
    } on DioException catch (e) {
      state = state.copyWith(
        errorMessage: DioExceptionHandler.handleException(e),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _loadHotelMarkers(final List<Hotel> hotels) async {
    final hotelIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/hotel-marker.png', size: 30);

    final hotelMarkers = hotels.map((final hotel) {
      return Marker(
        markerId: MarkerId('hotel-${hotel.id}'),
        position: LatLng(hotel.latitude!, hotel.longitude!),
        icon: hotelIcon,
        infoWindow: InfoWindow(title: hotel.name),
        onTap: () {
          final index = hotels.indexOf(hotel);
          setCurrentHotelIndex(index);
        },
      );
    }).toList();

    addMarkers(hotelMarkers);
  }

  void addMarkers(final List<Marker> markers) {
    state = state.copyWith(markers: [...state.markers, ...markers]);
  }

  void setCurrentHotelIndex(final int index) {
    state = state.copyWith(currentHotelIndex: index);
  }
}

final hotelControllerProvider =
    AutoDisposeNotifierProvider<HotelController, NearbyHotelState>(
      () => HotelController(),
    );
