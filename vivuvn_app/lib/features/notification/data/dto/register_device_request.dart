import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegisterDeviceRequest {
  final String fcmToken;
  final String deviceType;
  final String? deviceName;

  RegisterDeviceRequest({
    required this.fcmToken,
    required this.deviceType,
    this.deviceName,
  });

  RegisterDeviceRequest copyWith({
    final String? fcmToken,
    final String? deviceType,
    final String? deviceName,
  }) {
    return RegisterDeviceRequest(
      fcmToken: fcmToken ?? this.fcmToken,
      deviceType: deviceType ?? this.deviceType,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fcmToken': fcmToken,
      'deviceType': deviceType,
      'deviceName': deviceName,
    };
  }

  factory RegisterDeviceRequest.fromMap(final Map<String, dynamic> map) {
    return RegisterDeviceRequest(
      fcmToken: map['fcmToken'] as String,
      deviceType: map['deviceType'] as String,
      deviceName: map['deviceName'] != null
          ? map['deviceName'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterDeviceRequest.fromJson(final String source) =>
      RegisterDeviceRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
