// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'user.dart';

class Itinerary {
  final int id;
  final User owner;
  final bool isOwner;
  final bool isMember;
  final String name;
  final int startProvinceId;
  final String startProvinceName;
  final int destinationProvinceId;
  final String destinationProvinceName;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int groupSize;
  final int daysCount;
  final String transportationVehicle;
  final bool isPublic;
  final String? inviteCode;
  final int currentMemberCount;

  Itinerary({
    required this.id,
    required this.owner,
    required this.isOwner,
    required this.isMember,
    required this.name,
    required this.startProvinceId,
    required this.startProvinceName,
    required this.destinationProvinceId,
    required this.destinationProvinceName,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.groupSize,
    required this.daysCount,
    required this.transportationVehicle,
    required this.isPublic,
    this.inviteCode,
    this.currentMemberCount = 0,
  });

  Itinerary copyWith({
    final int? id,
    final User? owner,
    final bool? isOwner,
    final bool? isMember,
    final String? name,
    final int? startProvinceId,
    final String? startProvinceName,
    final int? destinationProvinceId,
    final String? destinationProvinceName,
    final String? imageUrl,
    final DateTime? startDate,
    final DateTime? endDate,
    final int? groupSize,
    final int? daysCount,
    final String? transportationVehicle,
    final bool? isPublic,
    final String? inviteCode,
    final int? currentMemberCount,
  }) {
    return Itinerary(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      isOwner: isOwner ?? this.isOwner,
      isMember: isMember ?? this.isMember,
      name: name ?? this.name,
      startProvinceId: startProvinceId ?? this.startProvinceId,
      startProvinceName: startProvinceName ?? this.startProvinceName,
      destinationProvinceId:
          destinationProvinceId ?? this.destinationProvinceId,
      destinationProvinceName:
          destinationProvinceName ?? this.destinationProvinceName,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      groupSize: groupSize ?? this.groupSize,
      daysCount: daysCount ?? this.daysCount,
      transportationVehicle:
          transportationVehicle ?? this.transportationVehicle,
      isPublic: isPublic ?? this.isPublic,
      inviteCode: inviteCode ?? this.inviteCode,
      currentMemberCount: currentMemberCount ?? this.currentMemberCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner.toMap(),
      'isOwner': isOwner,
      'isMember': isMember,
      'name': name,
      'startProvinceId': startProvinceId,
      'startProvinceName': startProvinceName,
      'destinationProvinceId': destinationProvinceId,
      'destinationProvinceName': destinationProvinceName,
      'imageUrl': imageUrl,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'groupSize': groupSize,
      'daysCount': daysCount,
      'transportationVehicle': transportationVehicle,
      'isPublic': isPublic,
      'inviteCode': inviteCode,
      'currentMemberCount': currentMemberCount,
    };
  }

  factory Itinerary.fromMap(final Map<String, dynamic> map) {
    // Ưu tiên lấy ownerId từ top level nếu có
    final ownerIdFromTop = map['ownerId']?.toString();
    
    // Parse owner object
    User owner;
    if (map['owner'] != null && map['owner'] is Map) {
      final ownerMap = map['owner'] as Map<String, dynamic>;
      // Nếu có ownerId từ top level, ưu tiên dùng nó
      if (ownerIdFromTop != null) {
        owner = User(
          id: ownerIdFromTop,
          username: ownerMap['username']?.toString() ?? '',
          email: ownerMap['email']?.toString() ?? '',
          phoneNumber: ownerMap['phoneNumber']?.toString(),
          userPhoto: ownerMap['userPhoto']?.toString(),
          googleIdToken: ownerMap['googleIdToken']?.toString(),
          isLocked: ownerMap['isLocked'] as bool? ?? false,
          roles: ownerMap['roles'] != null
              ? List<String>.from(ownerMap['roles'].map((final e) => e.toString()))
              : null,
        );
      } else {
        owner = User.fromMap(ownerMap);
      }
    } else {
      // Fallback nếu không có owner object
      owner = User(
        id: ownerIdFromTop ?? '',
        username: map['ownerUsername']?.toString() ?? '',
        email: map['ownerEmail']?.toString() ?? '',
        phoneNumber: map['ownerPhoneNumber']?.toString(),
        userPhoto: map['ownerUserPhoto']?.toString(),
        googleIdToken: map['ownerGoogleIdToken']?.toString(),
        isLocked: map['ownerIsLocked'] as bool? ?? false,
        roles: map['ownerRoles'] != null
            ? List<String>.from(map['ownerRoles'].map((final e) => e.toString()))
            : null,
      );
    }
    
    return Itinerary(
      id: map['id'] as int,
      owner: owner,
      isOwner: map['isOwner'] as bool? ?? false,
      isMember: map['isMember'] as bool? ?? false,
      name: map['name'].toString(),
      startProvinceId: map['startProvinceId'] as int,
      startProvinceName: map['startProvinceName'].toString(),
      destinationProvinceId: map['destinationProvinceId'] as int,
      destinationProvinceName: map['destinationProvinceName'].toString(),
      imageUrl: map['imageUrl']?.toString() ?? '',
      startDate: map['startDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : DateTime.parse(map['endDate'] as String),
      groupSize: map['groupSize'] as int? ?? 1,
      daysCount: map['daysCount'] as int? ?? 1,
      transportationVehicle: map['transportationVehicle']?.toString() ?? '',
      isPublic: map['isPublic'] as bool? ?? false,
      inviteCode: map['inviteCode']?.toString(),
      currentMemberCount: map['currentMemberCount'] as int? ??
          map['currentMember'] as int? ??
          0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Itinerary.fromJson(final String source) =>
      Itinerary.fromMap(json.decode(source) as Map<String, dynamic>);
}
