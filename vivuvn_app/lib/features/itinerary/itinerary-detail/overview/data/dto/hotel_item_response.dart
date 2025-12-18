class HotelItemResponse {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? note;
  final double? cost;
  final String? placeUri;
  final String? directionsUri;
  final double? latitude;
  final double? longitude;

  HotelItemResponse({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.checkInDate,
    this.checkOutDate,
    this.note,
    this.cost,
    this.placeUri,
    this.directionsUri,
    this.latitude,
    this.longitude,
  });

  factory HotelItemResponse.fromJson(final Map<String, dynamic> json) {
    final nestedHotel = json['hotel'] as Map<String, dynamic>?;
    final dynamic rawId =
        json['id'] ??
        json['hotelId'] ??
        nestedHotel?['id'] ??
        nestedHotel?['googlePlaceId'];
    final id = rawId != null ? rawId.toString() : '';

    final name =
        (json['name'] as String?) ?? (nestedHotel?['name'] as String?) ?? '';

    final address =
        (json['address'] as String?) ??
        (nestedHotel?['address'] as String?) ??
        (json['formattedAddress'] as String?) ??
        (nestedHotel?['formattedAddress'] as String?) ??
        '';

    String? imageUrl;
    try {
      final photos =
          (nestedHotel?['photos'] ?? json['photos']) as List<dynamic>?;
      if (photos != null && photos.isNotEmpty) {
        final first = photos.first;
        if (first is String) {
          imageUrl = first;
        } else if (first is Map<String, dynamic>) {
          imageUrl = first['url'] as String?;
        }
      }
    } catch (e) {
      imageUrl = null;
    }

    final checkInStr =
        (json['checkIn'] as String?) ?? (json['checkInDate'] as String?);
    final checkOutStr =
        (json['checkOut'] as String?) ?? (json['checkOutDate'] as String?);

    return HotelItemResponse(
      id: id,
      name: name,
      address: address,
      imageUrl: imageUrl,
      checkInDate: checkInStr != null ? DateTime.tryParse(checkInStr) : null,
      checkOutDate: checkOutStr != null ? DateTime.tryParse(checkOutStr) : null,
      note: (json['notes'] as String?) ?? (nestedHotel?['notes'] as String?),
      cost: ((json['cost'] as num?) ?? (nestedHotel?['cost'] as num?))
          ?.toDouble(),
      placeUri: (nestedHotel?['placeUri'] ?? json['placeUri'])?.toString(),
      directionsUri: (nestedHotel?['directionsUri'] ?? json['directionsUri'])
          ?.toString(),
      latitude: ((nestedHotel?['latitude'] ?? json['latitude']) as num?)
          ?.toDouble(),
      longitude: ((nestedHotel?['longitude'] ?? json['longitude']) as num?)
          ?.toDouble(),
    );
  }
}
