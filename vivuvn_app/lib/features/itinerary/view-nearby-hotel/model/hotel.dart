import 'dart:convert';

import 'package:flutter/material.dart';

class Hotel {
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

  Hotel({
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

  Color getPriceLevelColor() {
    switch (priceLevel) {
      case 'PRICE_LEVEL_FREE':
      case 'PRICE_LEVEL_INEXPENSIVE':
        return Colors.green;
      case 'PRICE_LEVEL_MODERATE':
        return Colors.orange;
      case 'PRICE_LEVEL_EXPENSIVE':
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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

  factory Hotel.fromMap(final Map<String, dynamic> map) {
    return Hotel(
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

  factory Hotel.fromJson(final String source) =>
      Hotel.fromMap(json.decode(source) as Map<String, dynamic>);
}
