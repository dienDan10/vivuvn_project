class Itinerary {
  final int id;
  final String name;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;

  Itinerary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });

  factory Itinerary.fromJson(final Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as int,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/images-placeholder.jpeg',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}
