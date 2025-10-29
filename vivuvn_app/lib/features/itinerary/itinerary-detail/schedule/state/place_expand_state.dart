import 'package:equatable/equatable.dart';

class PlaceExpandState extends Equatable {
  final bool isExpanded;

  const PlaceExpandState({this.isExpanded = false});

  PlaceExpandState copyWith({final bool? isExpanded}) {
    return PlaceExpandState(isExpanded: isExpanded ?? this.isExpanded);
  }

  @override
  List<Object?> get props => [isExpanded];
}
