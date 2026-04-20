import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:UniStack/features/settings/widgets/denger_zone.dart';
import 'package:UniStack/features/settings/widgets/settings_tile.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,

      appBar: CustomAppBar(
        screenWidth: screenWidth,
        showBackButton: true,
        showLogoutButton: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// General
            const Text(
              "General Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Gap(screenHeight * 0.02),

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

            Gap(screenHeight * 0.05),

            /// Account
            const Text(
              "Account Management",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Gap(screenHeight * 0.03),

            dangerZone(context, screenHeight, screenWidth),

            Gap(screenHeight * 0.05),

            /// Logout
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.find<AuthController>().logout(),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
            Gap(screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
