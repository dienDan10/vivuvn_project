import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/statistics_state.dart';

class StatisticsController extends StateNotifier<StatisticsState> {
  StatisticsController() : super(const StatisticsState());

  void setDataByType(final Map<String, double> map) {
    state = state.copyWith(dataByType: map);
  }

  void setDataByDay(final Map<String, double> map) {
    state = state.copyWith(dataByDay: map);
  }

  void setDataByMember(final Map<String, double> map) {
    state = state.copyWith(dataByMember: map);
  }

  void setShowByType(final bool show) {
    state = state.copyWith(
      showByType: show,
      showByMember: false,
      clearSelectedKey: true,
    );
  }

  void toggleShowByType() {
    setShowByType(!state.showByType);
  }

  void setShowByMember(final bool show) {
    state = state.copyWith(
      showByMember: show,
      showByType: false,
      clearSelectedKey: true,
    );
  }

  void selectKey(final String key) {
    state = state.copyWith(selectedKey: key);
  }

  void clearSelection() {
    state = state.copyWith(clearSelectedKey: true);
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsController, StatisticsState>(
  (final ref) => StatisticsController(),
);


