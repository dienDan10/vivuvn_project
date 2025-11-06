import '../models/chart_data.dart';

class StatisticsState {
  final Map<String, double> dataByType;
  final Map<String, double> dataByDay;
  final Map<String, double> dataByMember;
  final bool showByType;
  final bool showByMember;
  final String? selectedKey;

  const StatisticsState({
    this.dataByType = const {},
    this.dataByDay = const {},
    this.dataByMember = const {},
    this.showByType = false,
    this.showByMember = false,
    this.selectedKey,
  });

  List<ChartData> get chartData {
    final source = showByMember
        ? dataByMember
        : (showByType ? dataByType : dataByDay);
    return source.entries
        .map((final e) => ChartData(e.key, e.value))
        .toList(growable: false);
  }

  StatisticsState copyWith({
    final Map<String, double>? dataByType,
    final Map<String, double>? dataByDay,
    final Map<String, double>? dataByMember,
    final bool? showByType,
    final bool? showByMember,
    final String? selectedKey,
    final bool clearSelectedKey = false,
  }) {
    return StatisticsState(
      dataByType: dataByType ?? this.dataByType,
      dataByDay: dataByDay ?? this.dataByDay,
      dataByMember: dataByMember ?? this.dataByMember,
      showByType: showByType ?? this.showByType,
      showByMember: showByMember ?? this.showByMember,
      selectedKey: clearSelectedKey ? null : (selectedKey ?? this.selectedKey),
    );
  }
}
