import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  RefreshTokenResponse({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory RefreshTokenResponse.fromMap(final Map<String, dynamic> map) {
    return RefreshTokenResponse(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RefreshTokenResponse.fromJson(final String source) =>
      RefreshTokenResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
