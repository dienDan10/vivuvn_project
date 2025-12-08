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
    return ItineraryDto(
      id: json['id'] as String,
      title: json['title'] as String,
      destination: json['destination'] as String,
      imageUrl: json['imageUrl'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      participantCount: json['participantCount'] as int,
      durationDays: json['durationDays'] as int,
      isPublic: json['isPublic'] as bool,
      owner: OwnerDto.fromJson(json['owner'] as Map<String, dynamic>),
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
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatarUrl': avatarUrl};
  }
}
