import 'package:flutter/material.dart';

class NotificationSettingsModel {
  final bool isEnabled;
  final bool messagesEnabled;
  final bool ordersEnabled;
  final bool updatesEnabled;
  final bool offersEnabled;
  final bool remindersEnabled;

  final bool soundEnabled;
  final bool vibrationEnabled;

  final TimeOfDay? dndStart;
  final TimeOfDay? dndEnd;

  const NotificationSettingsModel({
    this.isEnabled = true,
    this.messagesEnabled = true,
    this.ordersEnabled = true,
    this.updatesEnabled = true,
    this.offersEnabled = true,
    this.remindersEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.dndStart,
    this.dndEnd,
  });

  factory NotificationSettingsModel.defaults() =>
      const NotificationSettingsModel();

  NotificationSettingsModel copyWith({
    bool? isEnabled,
    bool? messagesEnabled,
    bool? ordersEnabled,
    bool? updatesEnabled,
    bool? offersEnabled,
    bool? remindersEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    TimeOfDay? dndStart,
    TimeOfDay? dndEnd,
    bool clearDnd = false,
  }) {
    return NotificationSettingsModel(
      isEnabled: isEnabled ?? this.isEnabled,
      messagesEnabled: messagesEnabled ?? this.messagesEnabled,
      ordersEnabled: ordersEnabled ?? this.ordersEnabled,
      updatesEnabled: updatesEnabled ?? this.updatesEnabled,
      offersEnabled: offersEnabled ?? this.offersEnabled,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      dndStart: clearDnd ? null : (dndStart ?? this.dndStart),
      dndEnd: clearDnd ? null : (dndEnd ?? this.dndEnd),
    );
  }
}
