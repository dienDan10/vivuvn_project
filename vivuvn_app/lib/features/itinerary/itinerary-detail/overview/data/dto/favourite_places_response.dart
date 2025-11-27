class FavouritePlacesResponse {
  final int idInWishlist;
  final int locationId;
  final String name;
  final String description;
  final String imageUrl;
  final String provinceName;
  final String? placeUri;
  final String? directionsUri;

  FavouritePlacesResponse({
    required this.idInWishlist,
    required this.locationId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.provinceName,
    this.placeUri,
    this.directionsUri,
  });

  factory FavouritePlacesResponse.fromJson(final Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;

    // Lấy ảnh đầu tiên từ list photos
    String imageUrl = '';
    final photos = location?['photos'] as List<dynamic>?;
    if (photos != null && photos.isNotEmpty) {
      imageUrl = photos[0] as String? ?? '';
    }

    return FavouritePlacesResponse(
      idInWishlist: json['id'] as int? ?? 0,
      locationId: location?['id'] as int? ?? 0,
      name: location?['name'] as String? ?? '',
      description: location?['description'] as String? ?? '',
      imageUrl: imageUrl,
      provinceName: location?['provinceName'] as String? ?? '',
      placeUri: location?['placeUri']?.toString(),
      directionsUri: location?['directionsUri']?.toString(),
    );
  }
}
