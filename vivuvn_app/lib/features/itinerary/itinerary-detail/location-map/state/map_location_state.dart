// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../schedule/model/itinerary_day.dart';
import '../data/modal/directions.dart';

class MapLocationState {
  final int selectedDayIndex;
  final List<ItineraryDay> days;
  final List<Marker> locationMarkers;
  final List<Directions> directions;
  final int currentItemIndex;

  MapLocationState({
    required this.selectedDayIndex,
    required this.days,
    this.locationMarkers = const [],
    this.directions = const [],
    this.currentItemIndex = 0,
  });

  MapLocationState copyWith({
    final int? selectedDayIndex,
    final List<ItineraryDay>? days,
    final List<Marker>? locationMarkers,
    final List<Directions>? directions,
    final int? currentItemIndex,
  }) {
    return MapLocationState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      days: days ?? this.days,
      locationMarkers: locationMarkers ?? this.locationMarkers,
      directions: directions ?? this.directions,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
    );
  }
}
