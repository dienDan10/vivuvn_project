import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/auth/controller/auth_controller.dart';
import '../../common/auth/state/auth_state.dart';
import '../../features/notification/data/model/notification_payload.dart';
import '../routes/routes.dart';
import 'local_notification_service.dart';

final notificationHandlerProvider = Provider<NotificationHandler>((final ref) {
  final localNotifications = ref.read(localNotificationServiceProvider);
  return NotificationHandler(localNotifications, ref);
});

class NotificationHandler {
  final LocalNotificationService _localNotifications;
  BuildContext? _context;
  final Ref _ref;

  Completer<void>? _authReadyCompleter;
  RemoteMessage? _pendingInitialMessage;

  NotificationHandler(this._localNotifications, this._ref);

  // Initialize notification handlers
  Future<void> initialize(final BuildContext context) async {
    _context = context;

    // Initialize local notifications
    await _localNotifications.initialize();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen((final RemoteMessage message) {
      _handleBackgroundMessageTap(message);
    });

    // Check if app was opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _pendingInitialMessage = initialMessage;

      // Wait for auth to complete
      await _waitForAuthentication();

      // Now navigate
      if (_pendingInitialMessage != null) {
        _handleBackgroundMessageTap(_pendingInitialMessage!);
        _pendingInitialMessage = null;
      }
    }
  }

  // Handle foreground message (show as toast-like notification)
  void _handleForegroundMessage(final RemoteMessage message) {
    // Show local notification (appears at top like toast)
    _localNotifications.showNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: _buildPayload(message.data),
    );
  }

  // Handle background/terminated message tap (navigate to notification tab)
  void _handleBackgroundMessageTap(final RemoteMessage message) {
    // Parse notification data
    //final payload = NotificationPayload.fromMap(message.data);
    // Navigate to notification tab
    _navigateToNotificationTab();
  }

  // Navigate to notification tab
  void _navigateToNotificationTab() {
    if (_context == null || !_context!.mounted) {
      return;
    }

    final authStatus = _ref.read(authControllerProvider).status;
    if (authStatus != AuthStatus.authenticated) {
      return;
    }

    _context!.go(notificationRoute);
  }

  // Build payload string from data
  String _buildPayload(final Map<String, dynamic> data) {
    final payload = NotificationPayload.fromMap(data);
    return payload.toJson();
  }

  /// Wait for authentication to complete
  Future<void> _waitForAuthentication() async {
    final authStatus = _ref.read(authControllerProvider).status;

    // Already authenticated? Navigate immediately
    if (authStatus == AuthStatus.authenticated) {
      return;
    }

    // Already unauthenticated? Don't wait
    if (authStatus == AuthStatus.unauthenticated) {
      return;
    }

    // Auth is in progress, wait for it
    _authReadyCompleter = Completer<void>();

    // Listen for auth completion
    _ref.listen<AuthStatus>(
      authControllerProvider.select((final state) => state.status),
      (final previous, final next) {
        if (next == AuthStatus.authenticated) {
          if (!_authReadyCompleter!.isCompleted) {
            _authReadyCompleter!.complete();
          }
        } else if (next == AuthStatus.unauthenticated) {
          if (!_authReadyCompleter!.isCompleted) {
            _authReadyCompleter!.complete();
          }
        }
      },
    );

    // Wait for auth to complete or timeout after 10 seconds
    try {
      await _authReadyCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {},
      );
    } catch (_) {}
  }

  // Update context (call this if context changes)
  void updateContext(final BuildContext context) {
    _context = context;
  }
}
