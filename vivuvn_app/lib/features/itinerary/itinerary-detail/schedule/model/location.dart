class Location {
  final int id;
  final String name;
  final String provinceName;
  final String description;
  final String address;
  final double rating;
  final int? ratingCount;
  final String? websiteUri;
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
    required this.photos,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] is int ? json['id'] : 0,
      name: json['name']?.toString() ?? '',
      provinceName: json['provinceName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      rating: (json['rating'] != null)
          ? (json['rating'] as num).toDouble()
          : 0.0,
      ratingCount:
          json['ratingCount'] is int ? json['ratingCount'] as int : null,
      websiteUri: json['websiteUri']?.toString(),
      photos: (json['photos'] as List?)
              ?.whereType<String>()
              .toList() ??
          [],
    );
  }
}