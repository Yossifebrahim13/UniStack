import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/widgets/profile_cards.dart';
import 'package:UniStack/features/auth/widgets/profile_tile.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final nameController = TextEditingController(
    text: AuthService.instance.auth.currentUser?.displayName ?? "",
  );

  List<Map<String, dynamic>> profileStats = [
    {
      "icon": Icons.question_mark_rounded,
      "title": "Total Questions",
      "value": "12",
      "color": AppColors.primary,
    },
    {
      "icon": Icons.question_answer,
      "title": "Total Answers",
      "value": "12",
      "color": AppColors.primary,
    },
    {
      "icon": Icons.check_circle_outline_rounded,
      "title": "Solved Questions",
      "value": "12",
      "color": AppColors.primary,
    },
  ];

  List<Map<String, dynamic>> profileSettings = [
    {
      "icon": Icons.person_outline_rounded,
      "title": "Edit Profile",
      "onTap": () {
        // Get.toNamed(AppRoutes.profile);
      },
    },
    {
      "icon": Icons.settings_outlined,
      "title": "Settings",
      "onTap": () {
        Get.toNamed(AppRoutes.settings);
      },
    },
    {
      "icon": Icons.logout,
      "title": "Logout",
      "onTap": () {
        // AuthService.instance.signOut();
      },
    },
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: screenWidth * 0.15,
                child: Text(
                  "U",
                  style: TextStyle(
                    fontSize: screenWidth * 0.12,
                    color: AppColors.card,
                  ),
                ),
              ),
            ),
            Gap(screenWidth * 0.05),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ali abuledahab",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(screenWidth * 0.02),
                Icon(
                  Icons.create_new_folder,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            Gap(screenWidth * 0.01),
            Text(
              "aliabueldahab2005@gmail.com",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            Gap(screenWidth * 0.2),
            SizedBox(
              height: screenHeight * 0.2,

              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: profileStats.length,
                separatorBuilder: (context, index) => Gap(screenWidth * 0.02),
                itemBuilder: (context, index) {
                  return profileCard(
                    screenWidth: screenWidth,
                    icon: profileStats[index]["icon"],
                    title: profileStats[index]["title"],
                    value: profileStats[index]["value"],
                    color: profileStats[index]["color"],
                  );
                },
              ),
            ),

            Gap(screenWidth * 0.05),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile Settings",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Gap(screenWidth * 0.02),
            // Settings Tile
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: profileSettings.length,
              itemBuilder: (context, index) {
                return profileTile(
                  profileSettings[index]["icon"],
                  profileSettings[index]["title"],
                  profileSettings[index]["onTap"],
                );
              },
            ),

            Gap(screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
