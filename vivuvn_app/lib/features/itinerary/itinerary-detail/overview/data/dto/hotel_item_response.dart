class HotelItemResponse {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? note;
  final double? cost;

  HotelItemResponse({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.checkInDate,
    this.checkOutDate,
    this.note,
    this.cost,
  });

  factory HotelItemResponse.fromJson(final Map<String, dynamic> json) {
    // Support two shapes:
    // 1) itinerary item { id, hotelId, hotel: { googlePlaceId, name, address, ... }, checkIn, checkOut }
    // 2) flat shape { id, name, address, checkInDate, checkOutDate }
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

    // Try several common keys for image/url
    final imageUrl =
        (json['imageUrl'] as String?) ?? (nestedHotel?['imageUrl'] as String?);

    // Date keys may be 'checkIn'/'checkOut' or 'checkInDate'/'checkOutDate'
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
    );
  }
}
