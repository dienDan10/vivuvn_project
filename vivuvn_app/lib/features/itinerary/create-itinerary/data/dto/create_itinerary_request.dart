// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateItineraryRequest {
  final String name;
  final int startProvinceId;
  final int destinationProvinceId;
  final DateTime startDate;
  final DateTime endDate;

  CreateItineraryRequest({
    required this.name,
    required this.startProvinceId,
    required this.destinationProvinceId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'startProvinceId': startProvinceId,
      'destinationProvinceId': destinationProvinceId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory CreateItineraryRequest.fromMap(final Map<String, dynamic> map) {
    return CreateItineraryRequest(
      name: map['name'] as String,
      startProvinceId: map['startProvinceId'] as int,
      destinationProvinceId: map['destinationProvinceId'] as int,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateItineraryRequest.fromJson(final String source) =>
      CreateItineraryRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
