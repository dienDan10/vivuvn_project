import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/card_expand_state.dart';

/// Controller for hotel card expand state
class HotelCardExpandController extends StateNotifier<CardExpandState> {
  HotelCardExpandController() : super(const CardExpandState());

  void toggle(final String hotelId) {
    final currentState = state.isExpanded(hotelId);
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[hotelId] = !currentState;
    state = state.copyWith(expandedCards: newMap);
  }

  void collapse(final String hotelId) {
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[hotelId] = false;
    state = state.copyWith(expandedCards: newMap);
  }

  void expand(final String hotelId) {
    final newMap = Map<String, bool>.from(state.expandedCards);
    newMap[hotelId] = true;
    state = state.copyWith(expandedCards: newMap);
  }

  void reset() {
    state = const CardExpandState();
  }
}

/// Provider for hotel card expand state
final hotelCardExpandControllerProvider =
    StateNotifierProvider<HotelCardExpandController, CardExpandState>(
      (final ref) => HotelCardExpandController(),
    );
