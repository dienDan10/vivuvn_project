// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateItineraryResponse {
  final int id;

  CreateItineraryResponse({required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id};
  }

  factory CreateItineraryResponse.fromMap(final Map<String, dynamic> map) {
    return CreateItineraryResponse(id: map['id'] as int);
  }

  String toJson() => json.encode(toMap());

  factory CreateItineraryResponse.fromJson(final String source) =>
      CreateItineraryResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
