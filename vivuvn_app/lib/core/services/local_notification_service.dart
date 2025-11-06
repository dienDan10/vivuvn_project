import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  final ref,
) {
  return LocalNotificationService();
});

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize local notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/icon_notification');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Show foreground notification
  Future<void> showNotification({
    required final int id,
    required final String title,
    required final String body,
    final String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'vivuvn_notifications',
          'VivuVN Notifications',
          channelDescription: 'Notifications for trip updates',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/icon_notification',
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(''),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Handle notification tap
  void _onNotificationTapped(final NotificationResponse response) {
    print('📱 Notification tapped: ${response.payload}');
    // This will be handled by NotificationHandler
  }

  /// Cancel notification
  Future<void> cancel(final int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // This is optional - the channel is created automatically on first notification
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'vivuvn_notifications', // Channel ID
      'VivuVN Notifications', // Channel name
      description: 'Notifications for trip updates',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
