import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/place_expand_state.dart';

final placeExpandControllerProvider =
    StateNotifierProvider.family<
      PlaceExpandController,
      PlaceExpandState,
      (int dayId, int index)
    >((final ref, final key) {
      return PlaceExpandController();
    });

class PlaceExpandController extends StateNotifier<PlaceExpandState> {
  PlaceExpandController() : super(const PlaceExpandState());

  void toggleExpand() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void collapse() {
    state = state.copyWith(isExpanded: false);
  }
}
