import 'package:UniStack/core/models/notification_settings_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  SharedPreferences keys
class _Keys {
  static const isEnabled = 'notif_isEnabled';
  static const messages = 'notif_messages';
  static const updates = 'notif_updates';
  static const sound = 'notif_sound';
  static const vibration = 'notif_vibration';
}

// FCM topic names
class _Topics {
  static const messages = 'messages';
  static const updates = 'updates';
  static const all = [messages, updates];
}

class NotificationSettingsController extends GetxController {
  // Reactive state
  final isEnabled = true.obs;
  final messagesEnabled = true.obs;
  final updatesEnabled = true.obs;

  // Optional extras
  final soundEnabled = true.obs;
  final vibrationEnabled = true.obs;

  //  Internal
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late final SharedPreferences _prefs;

  //  Lifecycle
  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  //  Load from SharedPreferences
  // ─────────────────────────────────────────────────────────────
  void _loadSettings() {
    isEnabled.value = _prefs.getBool(_Keys.isEnabled) ?? true;
    messagesEnabled.value = _prefs.getBool(_Keys.messages) ?? true;
    updatesEnabled.value = _prefs.getBool(_Keys.updates) ?? true;
    soundEnabled.value = _prefs.getBool(_Keys.sound) ?? true;
    vibrationEnabled.value = _prefs.getBool(_Keys.vibration) ?? true;

    debugPrint('[NotifSettings] Loaded from prefs');
  }

  //  Save to SharedPreferences
  Future<void> _save() async {
    await _prefs.setBool(_Keys.isEnabled, isEnabled.value);
    await _prefs.setBool(_Keys.messages, messagesEnabled.value);
    await _prefs.setBool(_Keys.updates, updatesEnabled.value);
    await _prefs.setBool(_Keys.sound, soundEnabled.value);
    await _prefs.setBool(_Keys.vibration, vibrationEnabled.value);
  }

  //  FCM topic helpers
  Future<void> _subscribe(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      debugPrint('[NotifSettings] Subscribed → $topic');
    } catch (e) {
      debugPrint('[NotifSettings] Subscribe error ($topic): $e');
    }
  }

  Future<void> _unsubscribe(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      debugPrint('[NotifSettings] Unsubscribed → $topic');
    } catch (e) {
      debugPrint('[NotifSettings] Unsubscribe error ($topic): $e');
    }
  }

  // Synchronises all FCM topics to match the current RxBool state.
  Future<void> _syncAllTopics() async {
    if (!isEnabled.value) {
      // Master OFF – unsubscribe from everything
      for (final t in _Topics.all) {
        await _unsubscribe(t);
      }
      return;
    }
    // Master ON – respect individual switches
    messagesEnabled.value
        ? await _subscribe(_Topics.messages)
        : await _unsubscribe(_Topics.messages);
    updatesEnabled.value
        ? await _subscribe(_Topics.updates)
        : await _unsubscribe(_Topics.updates);
  }

  //  Public toggle methods

  // Master switch – when turned OFF, all topics are unsubscribed.
  Future<void> toggleMaster() async {
    isEnabled.toggle();
    await _save();
    await _syncAllTopics();
  }

  Future<void> toggleMessages() async {
    if (!isEnabled.value) return;
    messagesEnabled.toggle();
    messagesEnabled.value
        ? await _subscribe(_Topics.messages)
        : await _unsubscribe(_Topics.messages);
    await _save();
  }

  Future<void> toggleUpdates() async {
    if (!isEnabled.value) return;
    updatesEnabled.toggle();
    updatesEnabled.value
        ? await _subscribe(_Topics.updates)
        : await _unsubscribe(_Topics.updates);
    await _save();
  }

  // Optional extras

  Future<void> toggleSound() async {
    soundEnabled.toggle();
    await _save();
  }

  Future<void> toggleVibration() async {
    vibrationEnabled.toggle();
    await _save();
  }

  Future<void> resetToDefault() async {
    isEnabled.value = true;
    messagesEnabled.value = true;
    updatesEnabled.value = true;
    soundEnabled.value = true;
    vibrationEnabled.value = true;

    await _save();
    await _syncAllTopics();

    Get.snackbar(
      'Reset',
      'Notification settings restored to defaults.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  NotificationSettingsModel get snapshot => NotificationSettingsModel(
    isEnabled: isEnabled.value,
    messagesEnabled: messagesEnabled.value,
    updatesEnabled: updatesEnabled.value,
    soundEnabled: soundEnabled.value,
    vibrationEnabled: vibrationEnabled.value,
  );
}
