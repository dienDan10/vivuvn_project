// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateUsernameResponse {
  final String message;
  final String newName;

  UpdateUsernameResponse({
    required this.message,
    required this.newName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'newName': newName,
    };
  }

  factory UpdateUsernameResponse.fromMap(final Map<String, dynamic> map) {
    return UpdateUsernameResponse(
      message: map['message'].toString(),
      newName: map['newName'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUsernameResponse.fromJson(final String source) =>
      UpdateUsernameResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

