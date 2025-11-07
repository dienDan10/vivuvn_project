import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddHotelToItineraryRequest {
  final int hotelId;
  AddHotelToItineraryRequest({required this.hotelId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'hotelId': hotelId};
  }

  factory AddHotelToItineraryRequest.fromMap(final Map<String, dynamic> map) {
    return AddHotelToItineraryRequest(hotelId: map['hotelId'] as int);
  }

  String toJson() => json.encode(toMap());

  factory AddHotelToItineraryRequest.fromJson(final String source) =>
      AddHotelToItineraryRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
