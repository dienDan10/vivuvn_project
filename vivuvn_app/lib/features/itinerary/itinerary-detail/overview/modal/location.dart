class Location {
  final int id;
  final String name;
  final String address;
  final String? provinceName;

  Location({
    required this.id,
    required this.name,
    required this.address,
    this.provinceName,
  });

  factory Location.fromJson(final Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      provinceName: json['provinceName'] as String?,
    );
  }
}
