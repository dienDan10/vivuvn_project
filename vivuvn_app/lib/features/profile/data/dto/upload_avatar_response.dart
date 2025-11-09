// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UploadAvatarResponse {
  final String message;
  final String url;

  UploadAvatarResponse({
    required this.message,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'url': url,
    };
  }

  factory UploadAvatarResponse.fromMap(final Map<String, dynamic> map) {
    return UploadAvatarResponse(
      message: map['message'].toString(),
      url: map['url'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadAvatarResponse.fromJson(final String source) =>
      UploadAvatarResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

