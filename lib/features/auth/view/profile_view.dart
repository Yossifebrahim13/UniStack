import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:UniStack/features/auth/widgets/profile_cards.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final authController = Get.find<AuthController>();

  List<Map<String, dynamic>> get profileStats => [
    {
      "icon": Icons.stars_rounded,
      "title": "Total Points",
      "value": authController.points.value.toString(),
      "color": AppColors.primary,
    },

    {
      "icon": Icons.question_mark_rounded,
      "title": "Total Questions",
      "value": authController.questionsCount.value.toString(),
      "color": AppColors.primary,
    },
    {
      "icon": Icons.question_answer,
      "title": "Total Answers",
      "value": authController.answersCount.value.toString(),
      "color": AppColors.primary,
    },
    {
      "icon": Icons.check_circle_outline_rounded,
      "title": "Best Answer",
      "value": authController.correctAnswers.value.toString(),
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    authController.loadUserStats();
    super.dispose();
  }

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
              child: Obx(
                () => CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: screenWidth * 0.15,
                  child: Text(
                    authController.currentUser?.displayName![0].toUpperCase() ??
                        "U",
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      color: AppColors.card,
                    ),
                  ),
                ),
              ),
            ),
            Gap(screenHeight * 0.01),

            Obx(
              () => Text(
                authController.currentUser?.displayName ?? "",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(screenHeight * 0.01),
            Obx(
              () => Text(
                authController.currentUser?.email ?? "",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Gap(screenHeight * 0.05),

            Obx(
              () => Container(
                decoration: BoxDecoration(
                  gradient: authController.rank.value == 1
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.warning, AppColors.textPrimary],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.icon],
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.card.withOpacity(0.7),

                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.leaderboard,
                      color: authController.rank.value == 1
                          ? AppColors.warning
                          : AppColors.primary,
                    ),
                  ),
                  title: Text(
                    "Rank",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.card,
                    ),
                  ),
                  trailing: Text(
                    authController.rank.value.toString(),
                    style: TextStyle(
                      color: authController.rank.value == 1
                          ? AppColors.warning
                          : AppColors.card,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Gap(screenHeight * 0.05),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: screenWidth * 0.02,
                crossAxisSpacing: screenWidth * 0.02,
                childAspectRatio: 1,
              ),
              itemCount: profileStats.length,
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
          ],
        ),
      ),
    );
  }
}
