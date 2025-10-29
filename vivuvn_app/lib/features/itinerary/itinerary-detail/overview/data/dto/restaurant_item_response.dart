class RestaurantItemResponse {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? mealDate;
  final String? note;
  final double? cost;

  RestaurantItemResponse({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.mealDate,
    this.note,
    this.cost,
  });

  factory RestaurantItemResponse.fromJson(final Map<String, dynamic> json) {
    // The server returns items either as a flat object or with a nested
    // 'restaurant' object when returned as part of an itinerary list. Handle
    // both shapes.
    final nested = (json['restaurant'] is Map<String, dynamic>)
        ? (json['restaurant'] as Map<String, dynamic>)
        : json;

    // Item id (itinerary item) is usually at top-level 'id'. Fallback to
    // 'restaurantId' or nested restaurant id/googlePlaceId when needed.
    final idValue =
        json['id'] ??
        json['restaurantId'] ??
        nested['id'] ??
        nested['googlePlaceId'];

    // Name and address come from the nested restaurant object when present.
    final nameValue = nested['name'] ?? nested['title'] ?? '';
    final addressValue = nested['address'] ?? nested['formattedAddress'] ?? '';

    // imageUrl: if the restaurant has photos, try to extract a usable url.
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
    } catch (_) {
      image = null;
    }

    // mealDate: server returns separate 'date' and 'time' fields at top-level
    // for itinerary items. Prefer combining them. Fallback to nested 'mealDate'
    // or 'date'.
    DateTime? mealDate;
    try {
      final dateStr = (json['date'] ?? nested['date']) as String?;
      final timeStr = (json['time'] ?? nested['time']) as String?;
      if (dateStr != null && timeStr != null) {
        // Construct an ISO-like datetime string and parse.
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
    );
  }
}
