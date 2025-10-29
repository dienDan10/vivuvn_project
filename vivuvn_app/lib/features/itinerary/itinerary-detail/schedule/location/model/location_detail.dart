class LocationDetail {
  final int id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int ratingCount;
  final String? websiteUri;
  final String? placeUri;
  final String? directionsUri;
  final List<String> photos;

  LocationDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.ratingCount,
    this.websiteUri,
    this.placeUri,
    this.directionsUri,
    required this.photos,
  });

  factory LocationDetail.fromJson(final Map<String, dynamic> json) {
    return LocationDetail(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: json['ratingCount'] ?? 0,
      websiteUri: json['websiteUri'],
      placeUri: json['placeUri'],
      directionsUri: json['directionsUri'],
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((final e) => e as String)
              .toList() ??
          [],
    );
  }
}
