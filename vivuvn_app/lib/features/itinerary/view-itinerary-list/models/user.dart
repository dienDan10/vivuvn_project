// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? userPhoto;
  final String? googleIdToken;
  final bool isLocked;
  final List<String>? roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.userPhoto,
    this.googleIdToken,
    this.isLocked = false,
    this.roles = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'userPhoto': userPhoto,
      'googleIdToken': googleIdToken,
      'isLocked': isLocked,
      'roles': roles,
    };
  }

  factory User.fromMap(final Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      username: map['username'].toString(),
      email: map['email'].toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      userPhoto: map['userPhoto']?.toString(),
      googleIdToken: map['googleIdToken']?.toString(),
      isLocked: map['isLocked'] as bool? ?? false,
      roles: map['roles'] != null
          ? List<String>.from(map['roles'].map((final e) => e.toString()))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(final String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    final String? id,
    final String? username,
    final String? email,
    final String? phoneNumber,
    final String? userPhoto,
    final String? googleIdToken,
    final bool? isLocked,
    final List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userPhoto: userPhoto ?? this.userPhoto,
      googleIdToken: googleIdToken ?? this.googleIdToken,
      isLocked: isLocked ?? this.isLocked,
      roles: roles ?? this.roles,
    );
  }
}
