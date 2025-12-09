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
    // Map from API response format
    final id = json['id']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final location = json['provinceName']?.toString() ?? 
                     json['address']?.toString() ?? 
                     json['location']?.toString() ?? '';
    
    // Use first photo if available, otherwise use imageUrl
    final photos = json['photos'] as List<dynamic>?;
    final imageUrl = (photos != null && photos.isNotEmpty)
        ? photos.first.toString()
        : json['imageUrl']?.toString() ?? '';
    
    final rating = (json['rating'] != null)
        ? (json['rating'] as num).toDouble()
        : 0.0;
    
    final description = json['description']?.toString();

    return DestinationDto(
      id: id,
      name: name,
      location: location,
      imageUrl: imageUrl,
      rating: rating,
      description: description,
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
