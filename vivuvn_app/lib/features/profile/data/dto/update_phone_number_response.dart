// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdatePhoneNumberResponse {
  final String message;
  final String newPhoneNumber;

  UpdatePhoneNumberResponse({
    required this.message,
    required this.newPhoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'newPhoneNumber': newPhoneNumber,
    };
  }

  factory UpdatePhoneNumberResponse.fromMap(final Map<String, dynamic> map) {
    return UpdatePhoneNumberResponse(
      message: map['message'].toString(),
      newPhoneNumber: map['newPhoneNumber'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePhoneNumberResponse.fromJson(final String source) =>
      UpdatePhoneNumberResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

