// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChangePasswordResponse {
  final String message;

  ChangePasswordResponse({
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ChangePasswordResponse.fromMap(final Map<String, dynamic> map) {
    return ChangePasswordResponse(
      message: map['message'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordResponse.fromJson(final String source) =>
      ChangePasswordResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

