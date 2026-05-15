import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/notifications/controllers/notification_settings_controller.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NotificationSettingsView extends StatelessWidget {
  NotificationSettingsView({super.key});

  final NotificationSettingsController _controller =
      Get.find<NotificationSettingsController>();

  @override
  Widget build(BuildContext context) {
    final sw = AppSizes(context).screenWidth;
    final sh = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: CustomAppBar(
        screenWidth: sw,
        showBackButton: true,
        showLogoutButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.05,
          vertical: sh * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification Settings",
              style: TextStyle(
                fontSize: sw * 0.06,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Gap(sh * 0.008),
            Text(
              'Control what alerts you receive from UniStack.',
              style: TextStyle(
                fontSize: sw * 0.036,
                color: AppColors.textSecondary,
              ),
            ),
            Gap(sh * 0.03),

            // Master switch
            _masterNotificationCard(sw),
            Gap(sh * 0.03),

            // Individual switches
            _sectionLabel('Notification Types', sw),
            Gap(sh * 0.012),
            _individualCard(sw),
            Gap(sh * 0.03),

            // Sound & Vibration
            _sectionLabel('Audio & Haptics', sw),
            Gap(sh * 0.012),
            _audioCard(sw),
            Gap(sh * 0.03),

            // Reset button
            _resetButton(sw),
            Gap(sh * 0.04),
          ],
        ),
      ),
    );
  }

  // Widgets

  Widget _sectionLabel(String text, double sw) => Text(
    text,
    style: TextStyle(
      fontSize: sw * 0.042,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 0.3,
    ),
  );

  //  Master switch card
  Widget _masterNotificationCard(double sw) {
    return Obx(() {
      final on = _controller.isEnabled.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: on
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
                ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: on
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: SwitchListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: sw * 0.05,
            vertical: 4,
          ),
          title: Text(
            'Enable Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: sw * 0.045,
              color: on ? Colors.white : AppColors.textSecondary,
            ),
          ),
          subtitle: Text(
            on ? 'You are receiving all active alerts' : 'All alerts paused',
            style: TextStyle(
              fontSize: sw * 0.033,
              color: on ? Colors.white70 : AppColors.textHint,
            ),
          ),
          secondary: Icon(
            on
                ? Icons.notifications_active_rounded
                : Icons.notifications_off_rounded,
            color: on ? Colors.white : AppColors.textHint,
            size: sw * 0.07,
          ),
          value: on,
          onChanged: (_) => _controller.toggleMaster(),
          activeColor: Colors.white,
          activeTrackColor: Colors.white30,
          inactiveThumbColor: AppColors.textHint,
          inactiveTrackColor: Colors.white,
        ),
      );
    });
  }

  // Individual switches card
  Widget _individualCard(double sw) {
    return Obx(() {
      final masterOn = _controller.isEnabled.value;
      return _card(
        child: Column(
          children: [
            _switchTile(
              icon: Icons.chat_bubble_outline_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Messages',
              subtitle: 'Direct messages & replies',
              value: _controller.messagesEnabled.value,
              onChanged: (_) => _controller.toggleMessages(),
              enabled: masterOn,
            ),
            _divider(),
            _switchTile(
              icon: Icons.system_update_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: 'App Updates',
              subtitle: 'New features & improvements',
              value: _controller.updatesEnabled.value,
              onChanged: (_) => _controller.toggleUpdates(),
              enabled: masterOn,
            ),
          ],
        ),
      );
    });
  }

  // Audio card
  Widget _audioCard(double sw) {
    return Obx(() {
      final masterOn = _controller.isEnabled.value;
      return _card(
        child: Column(
          children: [
            _switchTile(
              icon: Icons.volume_up_rounded,
              iconColor: AppColors.primary,
              title: 'Sound',
              subtitle: 'Play sound for notifications',
              value: _controller.soundEnabled.value,
              onChanged: (_) => _controller.toggleSound(),
              enabled: masterOn,
            ),
            _divider(),
            _switchTile(
              icon: Icons.vibration_rounded,
              iconColor: AppColors.primary,
              title: 'Vibration',
              subtitle: 'Vibrate on notification',
              value: _controller.vibrationEnabled.value,
              onChanged: (_) => _controller.toggleVibration(),
              enabled: masterOn,
            ),
          ],
        ),
      );
    });
  }

  // Reset button
  Widget _resetButton(double sw) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.restore_rounded),
        label: const Text('Reset to Defaults'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: sw * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Reset Settings?'),
            content: const Text(
              'All notification preferences will be restored to their defaults.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  _controller.resetToDefault();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable sub-widgets

  Widget _card({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );

  Widget _divider() =>
      const Divider(height: 0, thickness: 0.5, indent: 16, endIndent: 16);

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.primary,
      ),
    );
  }
}
