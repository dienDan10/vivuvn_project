class Location {
  final int id;
  final String name;
  final String address;
  final String? provinceName;
  final String? googlePlaceId;

  Location({
    required this.id,
    required this.name,
    required this.address,
    this.provinceName,
    this.googlePlaceId,
  });

  factory Location.fromJson(final Map<String, dynamic> json) {
    // The backend search endpoints sometimes return different shapes
    // - saved itinerary items may include `id`, `name`, `address`, `provinceName`
    // - search endpoints may return `googlePlaceId`, `name`, `formattedAddress`
    // Make parsing resilient to both shapes.
    final googlePlaceId = json['googlePlaceId'] as String?;
    final id = (json['id'] is int)
        ? json['id'] as int
        : (googlePlaceId != null ? googlePlaceId.hashCode : 0);
    final name =
        (json['name'] as String?) ??
        (json['formattedAddress'] as String?) ??
        '';
    final address =
        (json['address'] as String?) ??
        (json['formattedAddress'] as String?) ??
        '';
    final provinceName = (json['provinceName'] as String?);

    return Location(
      id: id,
      name: name,
      address: address,
      provinceName: provinceName,
      googlePlaceId: googlePlaceId,
    );
  }
}
