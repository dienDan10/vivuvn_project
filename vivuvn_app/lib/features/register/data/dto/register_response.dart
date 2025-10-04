// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisterResponse {
  final String id;
  final String email;
  final String username;

  RegisterResponse({
    required this.id,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'email': email, 'username': username};
  }

  factory RegisterResponse.fromMap(final Map<String, dynamic> map) {
    return RegisterResponse(
      id: map['id'].toString(),
      email: map['email'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromJson(final String source) =>
      RegisterResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
