class Itinerary {
  final int id;
  final String name;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int groupSize;
  final String? destinationProvinceName;
  final String transportationVehicle;

  Itinerary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.groupSize,
    this.destinationProvinceName,
    this.transportationVehicle = '',
  });

  factory Itinerary.fromJson(final Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as int,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/images-placeholder.jpeg',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      groupSize: json['groupSize'] as int? ?? 0,
      destinationProvinceName:
          json['destinationProvinceName'] as String? ??
          json['destinationProvince'] as String?,
      transportationVehicle: json['transportationVehicle'] ?? '',
    );
  }
}
