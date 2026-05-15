import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:UniStack/core/database/user_store.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/notifications/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions
    await _requestPermission();

    // Get & persist FCM token
    await _setupToken();

    // Listen to foreground messages
    _listenForeground();

    // Handle notification tap when app was in background
    _listenOnMessageOpenedApp();

    // Handle notification tap when app was terminated
    await _handleInitialMessage();
  }

  // ── 2. Request permissions ────────────────────────────────
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');
  }

  // ── 3. Token management ───────────────────────────────────
  Future<void> _setupToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      debugPrint('[FCM] Token: $token');
      await _saveTokenToFirestore(token);
    }

    // Refresh token listener
    _fcm.onTokenRefresh.listen((newToken) async {
      debugPrint('[FCM] Token refreshed: $newToken');
      await _saveTokenToFirestore(newToken);
    });
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      await UserStore.instance.updateFcmToken(token);
    } catch (e) {
      debugPrint('[FCM] Failed to save token: $e');
    }
  }

  //  Foreground messages
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FCM] Foreground message: ${message.messageId}');
      _showLocalNotification(message);
    });
  }

  //  Background tap (app reopened from notification)
  void _listenOnMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FCM] onMessageOpenedApp: ${message.messageId}');
      _navigateFromMessage(message);
    });
  }

  //  Terminated tap
  Future<void> _handleInitialMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      debugPrint('[FCM] Initial message: ${message.messageId}');
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateFromMessage(message);
    }
  }

  //  Show local notification
  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? data['title'] ?? 'UniStack';
    final body =
        notification?.body ?? data['body'] ?? 'You have a new notification';
    final questionId = data['question_id'] as String?;

    LocalNotificationService.instance.showLocalNotification(
      title: title,
      body: body,
      questionId: questionId,
      dedupKey: message.messageId,
    );
  }

  void _navigateFromMessage(RemoteMessage message) {
    final questionId = message.data['question_id'] as String?;
    if (questionId != null && questionId.isNotEmpty) {
      Get.toNamed(AppRoutes.answers, arguments: questionId);
    }
  }

  Future<void> saveToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }
  }

  Future<void> subscribeToQuestion(String questionId) async {
    final topic = 'question_$questionId';
    await _fcm.subscribeToTopic(topic);
    debugPrint('[FCM] Subscribed to $topic');
  }

  Future<void> unsubscribeFromQuestion(String questionId) async {
    final topic = 'question_$questionId';
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('[FCM] Unsubscribed from $topic');
  }

  Future<void> subscribeToAllNotifications() async {
    await _fcm.subscribeToTopic('all_users');
  }

  Future<void> unsubscribeFromAllNotifications() async {
    await _fcm.unsubscribeFromTopic('all_users');
  }

  Future<String?> getToken() => _fcm.getToken();
}
