class ItineraryDto {
  final String id;
  final String title;
  final String destination;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int participantCount;
  final int durationDays;
  final bool isPublic;
  final OwnerDto owner;

  const ItineraryDto({
    required this.id,
    required this.title,
    required this.destination,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
    required this.durationDays,
    required this.isPublic,
    required this.owner,
  });

  factory ItineraryDto.fromJson(final Map<String, dynamic> json) {
    // Handle id as int or String
    final id = json['id']?.toString() ?? '';
    
    // Handle date parsing with fallback
    DateTime? parseDate(final dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (_) {
          return null;
        }
      }
      return null;
    }
    
    final startDate = parseDate(json['startDate']) ?? DateTime.now();
    final endDate = parseDate(json['endDate']) ?? DateTime.now();
    
    // Calculate durationDays if not provided
    final durationDays = json['durationDays'] as int? ?? 
                         endDate.difference(startDate).inDays + 1;
    
    // Map title - use 'name' field from API response
    final title = json['name']?.toString() ?? 
                  json['title']?.toString() ?? '';
    
    // Map destination - use destinationProvinceName or startProvinceName
    final destination = json['destinationProvinceName']?.toString() ?? 
                        json['destination']?.toString() ?? 
                        json['destinationName']?.toString() ?? 
                        json['startProvinceName']?.toString() ?? '';
    
    // Handle owner - may be nested or flat, or may not exist
    OwnerDto? owner;
    if (json['owner'] != null && json['owner'] is Map) {
      owner = OwnerDto.fromJson(json['owner'] as Map<String, dynamic>);
    } else if (json['ownerId'] != null || json['ownerName'] != null) {
      owner = OwnerDto(
        id: json['ownerId']?.toString() ?? '',
        name: json['ownerName']?.toString() ?? json['ownerUsername']?.toString() ?? '',
        avatarUrl: json['ownerAvatarUrl']?.toString(),
      );
    } else {
      // Default owner if not provided
      owner = const OwnerDto(id: '', name: 'Unknown');
    }
    
    return ItineraryDto(
      id: id,
      title: title,
      destination: destination,
      imageUrl: json['imageUrl']?.toString() ?? 
                json['coverImageUrl']?.toString() ?? 
                json['image']?.toString() ?? '',
      startDate: startDate,
      endDate: endDate,
      participantCount: json['participantCount'] as int? ?? 
                        json['memberCount'] as int? ?? 
                        json['participants'] as int? ?? 0,
      durationDays: durationDays,
      isPublic: json['isPublic'] as bool? ?? json['public'] as bool? ?? true, // Default to true for public itineraries
      owner: owner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participantCount': participantCount,
      'durationDays': durationDays,
      'isPublic': isPublic,
      'owner': owner.toJson(),
    };
  }

  String get formattedDateRange {
    final start = startDate.day.toString().padLeft(2, '0');
    final end =
        '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';
    return '$start-$end';
  }
}

class OwnerDto {
  final String id;
  final String name;
  final String? avatarUrl;

  const OwnerDto({required this.id, required this.name, this.avatarUrl});

  factory OwnerDto.fromJson(final Map<String, dynamic> json) {
    return OwnerDto(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? 
            json['username']?.toString() ?? 
            json['fullName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? 
                 json['avatar']?.toString() ?? 
                 json['userPhoto']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatarUrl': avatarUrl};
  }
}
