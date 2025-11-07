import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/toast/global_toast.dart';
import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../itinerary-detail/detail/controller/itinerary_detail_controller.dart';
import '../data/model/restaurant.dart';
import '../service/icon_service.dart';
import '../service/restaurant_service.dart';
import '../state/neary_by_restaurant_state.dart';

class RestaurantController extends AutoDisposeNotifier<NearbyRestaurantState> {
  @override
  NearbyRestaurantState build() {
    return NearbyRestaurantState();
  }

  Future<void> fetchNearbyRestaurants(final int locationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final restaurants = await ref
          .read(restaurantServiceProvider)
          .fetchNearbyRestaurants(locationId);

      state = state.copyWith(restaurants: restaurants);

      await _loadRestaurantMarkers(restaurants);
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

  Future<void> _loadRestaurantMarkers(
    final List<Restaurant> restaurants,
  ) async {
    final restaurantIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap(
          'assets/icons/restaurant-marker.png',
          size: 30,
        );

    final restaurantMarkers = restaurants.map((final restaurant) {
      return Marker(
        markerId: MarkerId('restaurant-${restaurant.id}'),
        position: LatLng(restaurant.latitude!, restaurant.longitude!),
        icon: restaurantIcon,
        infoWindow: InfoWindow(title: restaurant.name),
        onTap: () {
          final index = restaurants.indexOf(restaurant);
          setCurrentRestaurantIndex(index);
        },
      );
    }).toList();

    addMarkers(restaurantMarkers);
  }

  void addMarkers(final List<Marker> markers) {
    state = state.copyWith(markers: [...state.markers, ...markers]);
  }

  void setCurrentRestaurantIndex(final int index) {
    state = state.copyWith(currentRestaurantIndex: index);
  }

  Future<void> addRestaurantToItinerary(
    final int restaurantId,
    final BuildContext context,
  ) async {
    state = state.copyWith(isAddingToItinerary: true, errorMessage: null);
    final int itineraryId = ref
        .read(itineraryDetailControllerProvider)
        .itinerary!
        .id;
    try {
      await ref
          .read(restaurantServiceProvider)
          .addRestaurantToItinerary(restaurantId, itineraryId);
      if (context.mounted) {
        GlobalToast.showSuccessToast(
          context,
          message: 'Đã thêm nhà hàng vào hành trình',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        errorMessage: DioExceptionHandler.handleException(e),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred');
    } finally {
      state = state.copyWith(isAddingToItinerary: false);
    }
  }
}

final restaurantControllerProvider =
    AutoDisposeNotifierProvider<RestaurantController, NearbyRestaurantState>(
      () => RestaurantController(),
    );
