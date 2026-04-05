import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/settings/widgets/settings_tile.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:gap/gap.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    return Scaffold(
      backgroundColor: AppColors.scaffold,

      appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// General
            const Text(
              "General Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(16),

            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  settingsTile(Icons.notifications, "Notifications", () {}),
                  Divider(thickness: 0.5),
                  settingsTile(Icons.security, "Privacy & Security", () {}),
                  Divider(thickness: 0.5),
                  settingsTile(Icons.language, "Language", () {}),
                  Divider(thickness: 0.5),
                  settingsTile(Icons.help, "Help & Support", () {}),
                ],
              ),
            ),

            const Gap(24),

            /// Account
            const Text(
              "Account Management",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(16),

            _dangerZone(context),
          ],
        ),
      ),
    );
  }


  Widget _dangerZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Danger Zone",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.warning, color: Colors.red),
              ),
            ],
          ),

          const Gap(8),

          const Text(
            "Permanently delete your account and all associated data.",
            style: TextStyle(color: AppColors.textSecondary),
          ),

          const Gap(16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Warning: This action is irreversible.",
              style: TextStyle(color: Colors.red),
            ),
          ),

          const Gap(16),

          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _showDeleteDialog(context);
            },
            child: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.delete, color: Colors.red, size: 40),
              Gap(10),
              Text(
                "Are you sure?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Text(
                "This action cannot be undone.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
