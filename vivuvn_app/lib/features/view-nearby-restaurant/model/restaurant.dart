// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Restaurant {
  final int id;
  final String name;
  final String address;
  final double? rating;
  final String googlePlaceId;
  final int? userRatingCount;
  final double? latitude;
  final double? longitude;
  final String? googleMapsUri;
  final String? priceLevel;
  final List<String> photos;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    this.rating,
    required this.googlePlaceId,
    this.userRatingCount,
    this.latitude,
    this.longitude,
    this.googleMapsUri,
    this.priceLevel,
    this.photos = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'googlePlaceId': googlePlaceId,
      'userRatingCount': userRatingCount,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsUri': googleMapsUri,
      'priceLevel': priceLevel,
      'photos': photos,
    };
  }

  factory Restaurant.fromMap(final Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      googlePlaceId: map['googlePlaceId'] as String,
      userRatingCount: map['userRatingCount'] != null
          ? map['userRatingCount'] as int
          : null,
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      googleMapsUri: map['googleMapsUri'] != null
          ? map['googleMapsUri'] as String
          : null,
      priceLevel: map['priceLevel'] != null
          ? map['priceLevel'] as String
          : null,
      photos: map['photos'] != null
          ? List<String>.from(map['photos'] as List<dynamic>)
          : const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(final String source) =>
      Restaurant.fromMap(json.decode(source) as Map<String, dynamic>);
}
