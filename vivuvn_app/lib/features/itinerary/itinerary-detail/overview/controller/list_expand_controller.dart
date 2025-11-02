import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/list_expand_state.dart';

/// Controller for hotel list expand state
class HotelListExpandController extends StateNotifier<ListExpandState> {
  HotelListExpandController() : super(const ListExpandState());

  void toggle() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void collapse() {
    state = state.copyWith(isExpanded: false);
  }

  void expand() {
    state = state.copyWith(isExpanded: true);
  }
}

/// Controller for restaurant list expand state
class RestaurantListExpandController extends StateNotifier<ListExpandState> {
  RestaurantListExpandController() : super(const ListExpandState());

  void toggle() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void collapse() {
    state = state.copyWith(isExpanded: false);
  }

  void expand() {
    state = state.copyWith(isExpanded: true);
  }
}

/// Provider for hotel list expand state
final hotelListExpandControllerProvider =
    StateNotifierProvider<HotelListExpandController, ListExpandState>(
      (final ref) => HotelListExpandController(),
    );

/// Provider for restaurant list expand state
final restaurantListExpandControllerProvider =
    StateNotifierProvider<RestaurantListExpandController, ListExpandState>(
      (final ref) => RestaurantListExpandController(),
    );
