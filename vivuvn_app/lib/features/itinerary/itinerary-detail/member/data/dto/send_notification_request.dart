import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendNotificationRequest {
  final String title;
  final String message;
  final bool? sendEmail;
  SendNotificationRequest({
    required this.title,
    required this.message,
    this.sendEmail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'sendEmail': sendEmail,
    };
  }

  factory SendNotificationRequest.fromMap(final Map<String, dynamic> map) {
    return SendNotificationRequest(
      title: map['title'] as String,
      message: map['message'] as String,
      sendEmail: map['sendEmail'] != null ? map['sendEmail'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendNotificationRequest.fromJson(final String source) =>
      SendNotificationRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
