import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/widgets/info_card.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:UniStack/shared/functions/date_format.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final nameController = TextEditingController(
    text: AuthService.instance.auth.currentUser?.displayName ?? "",
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    final user = AuthService.instance.auth.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          children: [
            Gap(screenHeight * 0.03),

            /// 👤 Profile Avatar
            Center(
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: screenWidth * 0.12,
                  color: AppColors.primary,
                ),
              ),
            ),

            Gap(screenHeight * 0.02),

            /// 👤 Name
            Center(
              child: Text(
                user?.displayName ?? "Anonymous",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            Gap(screenHeight * 0.01),

            /// 📧 Email
            Center(
              child: Text(
                user?.email ?? "No Email",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            Gap(screenHeight * 0.04),

            /// 📅 Join Date
            infoCard(
              title: "Joined At",
              value: formatDate(user?.metadata.creationTime ?? DateTime.now()),
              icon: Icons.calendar_today,
              screenWidth: screenWidth,
            ),

            Gap(screenHeight * 0.03),

            /// ✏️ Edit Username
            Text(
              "Edit Username",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),

            Gap(screenHeight * 0.015),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter new username",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                    ),
                  ),

                  Gap(screenHeight * 0.02),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await user?.updateDisplayName(nameController.text);

                        await user?.reload();

                        Get.snackbar(
                          "Success",
                          "Username updated",
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Gap(screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}
