import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:UniStack/core/utils/app_routes.dart';

@pragma('vm:entry-point')
void onBackgroundNotificationResponse(NotificationResponse response) {
  _navigateFromPayload(response.payload);
}

void _navigateFromPayload(String? payload) {
  if (payload == null || payload.isEmpty) return;
  try {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    final questionId = data['question_id'] as String?;
    if (questionId != null && questionId.isNotEmpty) {
      Get.toNamed(AppRoutes.answers, arguments: questionId);
    }
  } catch (e) {
    debugPrint('[LocalNotification] payload parse error: $e');
  }
}

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Channel constants
  static const String _channelId = 'unistack_answers_default_v1';
  static const String _channelName = 'UniStack Answers';
  static const String _channelDesc =
      'Notifications for new answers on your questions';
  static const String _groupKey = 'unistack_answers_group';
  static const String _groupChannelId = 'unistack_group_channel';

  final Set<String> _shownIds = {};

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateFromPayload(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
      settings: settings,
    );
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? questionId,
    String? dedupKey,
  }) async {
    // check if the notification is already shown
    if (dedupKey != null) {
      if (_shownIds.contains(dedupKey)) {
        debugPrint('[LocalNotification] duplicate skipped: $dedupKey');
        return;
      }
      _shownIds.add(dedupKey);
      if (_shownIds.length > 50) _shownIds.remove(_shownIds.first);
    }

    // Build payload
    final payload = questionId != null
        ? jsonEncode({'question_id': questionId})
        : null;

    final notifId = questionId != null
        ? questionId.hashCode.abs() % 100000
        : DateTime.now().millisecond;

    // Individual notification
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      playSound: true, // تفعيل صوت الجهاز الافتراضي
      styleInformation: BigTextStyleInformation(body),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: null, // استخدام صوت iOS الافتراضي
      ),
    );

    await _plugin.show(
      id: notifId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
    await _showGroupSummary();
  }

  Future<void> _showGroupSummary() async {
    const androidSummary = AndroidNotificationDetails(
      _groupChannelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.low,
      priority: Priority.low,
      groupKey: _groupKey,
      setAsGroupSummary: true,
      playSound: true,
    );

    const summaryDetails = NotificationDetails(android: androidSummary);

    await _plugin.show(
      id: 0,
      title: 'UniStack',
      body: 'You have new notifications',
      notificationDetails: summaryDetails,
    );
  }

  // ── Cancel all ────────────────────────────────────────────
  Future<void> cancelAll() => _plugin.cancelAll();
}
