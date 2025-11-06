import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FcmService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // request notification permission
  Future<bool> requestPermission() async {
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    } else {
      return false;
    }
  }

  // get FCM token
  Future<String?> getToken() async {
    try {
      final String? token = await _fcm.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  // Get device type
  String getDeviceType() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'web';
  }

  // Get device name
  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      return 'Android Device';
    } else if (Platform.isIOS) {
      return 'iOS Device';
    }
    return 'Unknown Device';
  }

  // Listen to token refresh
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  // Delete FCM token (for logout)
  Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
    } catch (e) {
      // Handle error
    }
  }
}

final fcmServiceProvider = Provider<FcmService>((final ref) {
  return FcmService();
});
