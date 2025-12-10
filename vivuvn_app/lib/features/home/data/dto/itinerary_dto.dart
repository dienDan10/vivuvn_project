class ItineraryDto {
  final String id;
  final String title;
  final String destination;
  final String startProvinceName;
  final String destinationProvinceName;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int participantCount;
  final int currentMemberCount;
  final int groupSize;
  final int durationDays;
  final bool isPublic;
  final OwnerDto owner;
  final bool isOwner;
  final bool isMember;

  const ItineraryDto({
    required this.id,
    required this.title,
    required this.destination,
    required this.startProvinceName,
    required this.destinationProvinceName,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
    required this.currentMemberCount,
    required this.groupSize,
    required this.durationDays,
    required this.isPublic,
    required this.owner,
    this.isOwner = false,
    this.isMember = false,
  });

  factory ItineraryDto.fromJson(final Map<String, dynamic> json) {
    // Handle id as int or String
    final id = json['id']?.toString() ?? '';
    
    bool? parseBool(final dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true' || lower == '1') return true;
        if (lower == 'false' || lower == '0') return false;
      }
      if (value is num) {
        if (value == 1) return true;
        if (value == 0) return false;
      }
      return null;
    }

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
    final startProvinceName = json['startProvinceName']?.toString() ?? '';
    final destinationProvinceName =
        json['destinationProvinceName']?.toString() ?? destination;
    
    // Handle owner - ưu tiên lấy ownerId từ top level, sau đó mới lấy từ nested owner object
    OwnerDto? owner;
    
    // Ưu tiên: lấy ownerId từ top level nếu có
    final ownerIdFromTop = json['ownerId']?.toString();
    
    if (json['owner'] != null && json['owner'] is Map) {
      final ownerMap = json['owner'] as Map<String, dynamic>;
      // Nếu có ownerId từ top level, ưu tiên dùng nó
      // Xử lý cả trường hợp id là int hoặc string
      String? ownerIdFromMap;
      if (ownerMap['id'] != null) {
        ownerIdFromMap = ownerMap['id'].toString();
      } else if (ownerMap['userId'] != null) {
        ownerIdFromMap = ownerMap['userId'].toString();
      }
      
      final finalOwnerId = ownerIdFromTop ?? ownerIdFromMap ?? '';
      
      owner = OwnerDto(
        id: finalOwnerId,
        name: ownerMap['name']?.toString() ?? 
              ownerMap['username']?.toString() ?? 
              ownerMap['fullName']?.toString() ?? 
              json['ownerName']?.toString() ?? 
              json['ownerUsername']?.toString() ?? '',
        avatarUrl: ownerMap['avatarUrl']?.toString() ?? 
                   ownerMap['avatar']?.toString() ?? 
                   ownerMap['userPhoto']?.toString() ??
                   json['ownerAvatarUrl']?.toString(),
      );
    } else if (ownerIdFromTop != null || json['ownerName'] != null || json['ownerUsername'] != null) {
      owner = OwnerDto(
        id: ownerIdFromTop ?? '',
        name: json['ownerName']?.toString() ?? 
              json['ownerUsername']?.toString() ?? 
              json['ownerFullName']?.toString() ?? '',
        avatarUrl: json['ownerAvatarUrl']?.toString() ?? 
                   json['ownerAvatar']?.toString() ??
                   json['ownerUserPhoto']?.toString(),
      );
    } else {
      // Default owner if not provided
      owner = const OwnerDto(id: '', name: 'Unknown');
    }
    
    final currentMemberCount = json['currentMemberCount'] as int? ??
        json['participantCount'] as int? ??
        json['memberCount'] as int? ??
        json['participants'] as int? ??
        0;

    final groupSize = json['groupSize'] as int? ??
        json['maxGroupSize'] as int? ??
        json['capacity'] as int? ??
        currentMemberCount;

    final participantCount = json['participantCount'] as int? ??
        json['memberCount'] as int? ??
        json['participants'] as int? ??
        currentMemberCount;

    return ItineraryDto(
      id: id,
      title: title,
      destination: destination,
      startProvinceName: startProvinceName,
      destinationProvinceName: destinationProvinceName,
      imageUrl: json['imageUrl']?.toString() ?? 
                json['coverImageUrl']?.toString() ?? 
                json['image']?.toString() ?? '',
      startDate: startDate,
      endDate: endDate,
      participantCount: participantCount,
      currentMemberCount: currentMemberCount,
      groupSize: groupSize,
      durationDays: durationDays,
      isPublic: json['isPublic'] as bool? ?? json['public'] as bool? ?? true, // Default to true for public itineraries
      owner: owner,
      isOwner: parseBool(json['isOwner']) ?? false,
      isMember: parseBool(json['isMember']) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'startProvinceName': startProvinceName,
      'destinationProvinceName': destinationProvinceName,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participantCount': participantCount,
      'currentMemberCount': currentMemberCount,
      'groupSize': groupSize,
      'durationDays': durationDays,
      'isPublic': isPublic,
      'owner': owner.toJson(),
      'isOwner': isOwner,
      'isMember': isMember,
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
