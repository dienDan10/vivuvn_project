// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateTransportationRequest {
  final String travelMode;
  UpdateTransportationRequest({required this.travelMode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'travelMode': travelMode};
  }

  factory UpdateTransportationRequest.fromMap(final Map<String, dynamic> map) {
    return UpdateTransportationRequest(travelMode: map['travelMode'] as String);
  }

  String toJson() => json.encode(toMap());

  factory UpdateTransportationRequest.fromJson(final String source) =>
      UpdateTransportationRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
