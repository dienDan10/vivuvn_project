import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/card_expand_state.dart';

/// Controller for restaurant card expand state
class RestaurantCardExpandController extends StateNotifier<CardExpandState> {
  RestaurantCardExpandController() : super(const CardExpandState());

  void toggle(String restaurantId) {
    final currentState = state.isExpanded(restaurantId);
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[restaurantId] = !currentState;
    state = state.copyWith(expandedCards: newMap);
  }

  void collapse(String restaurantId) {
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[restaurantId] = false;
    state = state.copyWith(expandedCards: newMap);
  }

  void expand(String restaurantId) {
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[restaurantId] = true;
    state = state.copyWith(expandedCards: newMap);
  }

  void reset() {
    state = const CardExpandState();
  }
}

/// Provider for restaurant card expand state
final restaurantCardExpandControllerProvider =
    StateNotifierProvider<RestaurantCardExpandController, CardExpandState>(
  (ref) => RestaurantCardExpandController(),
);
