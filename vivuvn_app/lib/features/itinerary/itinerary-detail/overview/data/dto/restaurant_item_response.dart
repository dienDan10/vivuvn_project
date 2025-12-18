class RestaurantItemResponse {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? mealDate;
  final String? note;
  final double? cost;
  final String? placeUri;
  final String? directionsUri;
  final double? latitude;
  final double? longitude;

  RestaurantItemResponse({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.mealDate,
    this.note,
    this.cost,
    this.placeUri,
    this.directionsUri,
    this.latitude,
    this.longitude,
  });

  factory RestaurantItemResponse.fromJson(final Map<String, dynamic> json) {
    final nested = (json['restaurant'] is Map<String, dynamic>)
        ? (json['restaurant'] as Map<String, dynamic>)
        : json;

    final idValue =
        json['id'] ??
        json['restaurantId'] ??
        nested['id'] ??
        nested['googlePlaceId'];

    final nameValue = nested['name'] ?? nested['title'] ?? '';
    final addressValue = nested['address'] ?? nested['formattedAddress'] ?? '';

    String? image;
    try {
      final photos = nested['photos'];
      if (photos is List && photos.isNotEmpty) {
        final first = photos.first;
        if (first is String) {
          image = first;
        } else if (first is Map<String, dynamic>) {
          image = first['url'] as String?;
        }
      }
    } catch (e) {
      image = null;
    }

    DateTime? mealDate;
    try {
      final dateStr = (json['date'] ?? nested['date']) as String?;
      final timeStr = (json['time'] ?? nested['time']) as String?;
      if (dateStr != null && timeStr != null) {
        final combined = '${dateStr}T$timeStr';
        mealDate = DateTime.tryParse(combined);
      } else if (dateStr != null) {
        mealDate = DateTime.tryParse(dateStr);
      } else if (nested['mealDate'] != null) {
        mealDate = DateTime.tryParse(nested['mealDate'] as String);
      }
    } catch (_) {
      mealDate = null;
    }

    return RestaurantItemResponse(
      id: idValue?.toString() ?? '',
      name: nameValue as String,
      address: addressValue as String,
      imageUrl: image,
      mealDate: mealDate,
      note: (json['notes'] as String?) ?? (nested['notes'] as String?),
      cost: ((json['cost'] as num?) ?? (nested['cost'] as num?))?.toDouble(),
      placeUri: (nested['placeUri'] ?? json['placeUri'])?.toString(),
      directionsUri: (nested['directionsUri'] ?? json['directionsUri'])
          ?.toString(),
      latitude: ((nested['latitude'] ?? json['latitude']) as num?)?.toDouble(),
      longitude: ((nested['longitude'] ?? json['longitude']) as num?)
          ?.toDouble(),
    );
  }
}
