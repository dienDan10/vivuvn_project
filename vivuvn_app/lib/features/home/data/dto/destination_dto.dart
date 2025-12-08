class DestinationDto {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final String? description;

  const DestinationDto({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    this.description,
  });

  factory DestinationDto.fromJson(final Map<String, dynamic> json) {
    return DestinationDto(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
    };
  }
}
