class Location {
  final int id;
  final String name;
  final String provinceName;
  final String description;
  final String address;
  final double rating;
  final int? ratingCount;
  final String? websiteUri;
  final String? placeUri;
  final String? directionsUri;
  final double? latitude;
  final double? longitude;

  final List<String> photos;

  Location({
    required this.id,
    required this.name,
    required this.provinceName,
    required this.description,
    required this.address,
    required this.rating,
    this.ratingCount,
    this.websiteUri,
    this.placeUri,
    this.directionsUri,
    this.latitude,
    this.longitude,
    required this.photos,
  });

  factory Location.fromJson(final Map<String, dynamic> json) {
    return Location(
      id: json['id'] is int ? json['id'] : 0,
      name: json['name']?.toString() ?? '',
      provinceName: json['provinceName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      rating: (json['rating'] != null)
          ? (json['rating'] as num).toDouble()
          : 0.0,
      ratingCount: json['ratingCount'] is int
          ? json['ratingCount'] as int
          : null,
      websiteUri: json['websiteUri']?.toString(),
      placeUri: json['placeUri']?.toString(),
      directionsUri: json['directionsUri']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      photos:
          (json['photos'] as List?)?.map((final e) => e.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provinceName': provinceName,
      'description': description,
      'address': address,
      'rating': rating,
      'ratingCount': ratingCount,
      'websiteUri': websiteUri,
      'placeUri': placeUri,
      'directionsUri': directionsUri,
      'latitude': latitude,
      'longitude': longitude,
      'photos': photos,
    };
  }
}
