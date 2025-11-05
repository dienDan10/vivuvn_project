import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Member {
  final int memberId;
  final String email;
  final String username;
  final String? photo;
  final String? phoneNumber;
  final String role;
  final DateTime joinedAt;

  Member({
    required this.memberId,
    required this.email,
    required this.username,
    this.photo,
    this.phoneNumber,
    required this.role,
    required this.joinedAt,
  });

  Member copyWith({
    final int? memberId,
    final String? email,
    final String? username,
    final String? photo,
    final String? phoneNumber,
    final String? role,
    final DateTime? joinedAt,
  }) {
    return Member(
      memberId: memberId ?? this.memberId,
      email: email ?? this.email,
      username: username ?? this.username,
      photo: photo ?? this.photo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'memberId': memberId,
      'email': email,
      'username': username,
      'photo': photo,
      'phoneNumber': phoneNumber,
      'role': role,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
    };
  }

  factory Member.fromMap(final Map<String, dynamic> map) {
    return Member(
      memberId: map['memberId'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      phoneNumber: map['phoneNumber'] != null
          ? map['phoneNumber'] as String
          : null,
      role: map['role'] as String,
      joinedAt: _parseDateTime(map['joinedAt']),
    );
  }

  static DateTime _parseDateTime(final dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Invalid datetime format: $value');
    }
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(final String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);
}
