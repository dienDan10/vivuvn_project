import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResetPasswordRequest {
  final String email;
  final String token;
  final String newPassword;
  ResetPasswordRequest({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'token': token,
      'newPassword': newPassword,
    };
  }

  factory ResetPasswordRequest.fromMap(final Map<String, dynamic> map) {
    return ResetPasswordRequest(
      email: map['email'] as String,
      token: map['token'] as String,
      newPassword: map['newPassword'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordRequest.fromJson(final String source) =>
      ResetPasswordRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
