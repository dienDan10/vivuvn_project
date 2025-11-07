import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddToItineraryRequest {
  final int restaurantId;
  AddToItineraryRequest({required this.restaurantId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'restaurantId': restaurantId};
  }

  factory AddToItineraryRequest.fromMap(final Map<String, dynamic> map) {
    return AddToItineraryRequest(restaurantId: map['restaurantId'] as int);
  }

  String toJson() => json.encode(toMap());

  factory AddToItineraryRequest.fromJson(final String source) =>
      AddToItineraryRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
