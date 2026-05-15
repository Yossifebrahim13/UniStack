import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:UniStack/features/settings/widgets/denger_zone.dart';
import 'package:UniStack/features/settings/widgets/settings_tile.dart';
import 'package:UniStack/features/settings/widgets/username_dialog.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _nameController = TextEditingController();
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
            Text(
              "General Settings",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Gap(screenHeight * 0.02),

            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  settingsTile(Icons.notifications, "Notifications", () {
                    Get.toNamed(AppRoutes.notificationSettings);
                  }),
                  const Divider(thickness: 0.5),
                  settingsTile(Icons.support_agent, "Help & Support", () {
                    Get.toNamed(AppRoutes.helpAndSupport);
                  }),
                ],
              ),
            ),

            Gap(screenHeight * 0.05),

            /// Account
            Text(
              "Account",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Gap(screenHeight * 0.03),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  settingsTile(
                    Icons.supervised_user_circle,
                    "Change Username",
                    () {
                      final formKey = GlobalKey<FormState>();
                      _nameController.text =
                          authController.currentUser?.displayName ?? '';
                      showDialog(
                        context: context,
                        builder: (context) => Form(
                          key: formKey,
                          child: Obx(
                            () => buildUserNameDialog(
                              context: context,
                              screenHeight: screenHeight,
                              onSubmit: () async {
                                if (formKey.currentState!.validate()) {
                                  await authController.updateUserName(
                                    _nameController.text.trim(),
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              isLoading: authController.isLoading.value,
                              controller: _nameController,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(thickness: 0.5),
                  settingsTile(Icons.lock_rounded, "Change Password", () {
                    authController.resetPassword(
                      authController.currentUser!.email!,
                    );
                    Get.offAllNamed(AppRoutes.root);
                  }),
                ],
              ),
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
                onPressed: () => authController.logout(),
                child: Text(
                  "Logout",
                  style: const TextStyle(color: AppColors.error),
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
