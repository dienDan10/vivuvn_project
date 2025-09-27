import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RefreshTokenResponse {
  final String status;
  final Data data;
  RefreshTokenResponse({required this.status, required this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'data': data.toMap()};
  }

  factory RefreshTokenResponse.fromMap(final Map<String, dynamic> map) {
    return RefreshTokenResponse(
      status: map['status'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RefreshTokenResponse.fromJson(final String source) =>
      RefreshTokenResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Data {
  final String refreshToken;
  final String accessToken;
  Data({required this.refreshToken, required this.accessToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }

  factory Data.fromMap(final Map<String, dynamic> map) {
    return Data(
      refreshToken: map['refreshToken'] as String,
      accessToken: map['accessToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(final String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);
}
