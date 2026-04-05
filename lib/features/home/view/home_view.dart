import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/home/controllers/home_controller.dart';
import 'package:UniStack/features/home/widgets/anouncment_card.dart';
import 'package:UniStack/features/home/widgets/quick_action_card.dart';
import 'package:UniStack/features/home/widgets/statues_card.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    List quickActions = [
      {
        "title": "Profile",
        "icon": Icons.person,
        "action": () => Get.offAllNamed(AppRoutes.profile),
      },
      {"title": "Settings", "icon": Icons.settings, "action": () => Get.offAllNamed(AppRoutes.settings)},
      {"title": "About", "icon": Icons.info, "action": () => {}},
    ];

    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    final controller = Get.find<HomeController>();

    return RefreshIndicator(
      onRefresh: () => controller.getStats(),
      color: AppColors.primary,
      backgroundColor: AppColors.sheetBackground,
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          children: [
            Gap(screenHeight * 0.02),

            Text(
              "Hello, ${AuthService.instance.auth.currentUser!.displayName} 👋",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Gap(screenHeight * 0.02),

            Obx(
              () => Skeletonizer(
                enabled: controller.isLoading.value,
                child: Row(
                  children: [
                    Expanded(
                      child: buildStatCard(
                        "Total Points",
                        "${controller.points}",
                        "PTS",
                        Icons.wallet,
                        AppColors.primary,
                      ),
                    ),
                    Gap(screenWidth * 0.02),
                    Expanded(
                      child: buildStatCard(
                        "Global Rank",
                        "${controller.rank}",
                        "RANK",
                        Icons.emoji_events,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(screenHeight * 0.06),

            Text(
              "Quick Actions",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
            Gap(screenHeight * 0.02),

            SizedBox(
              height: screenHeight * 0.15,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) =>
                    quickActionsCard(
                      quickActions[index]["icon"],
                      quickActions[index]["title"],
                      quickActions[index]["action"],
                    ),
                separatorBuilder: (BuildContext context, int index) =>
                    Gap(screenWidth * 0.02),
                itemCount: quickActions.length,
              ),
            ),

            Gap(screenHeight * 0.05),

            Text(
              "Announcements",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
            Gap(screenHeight * 0.02),

            announcementCard(
              "Welcome to UniStack!",
              "Check out the new learning resources available now.",
              Icons.campaign_rounded,
              AppColors.primary,
              () => {},
              screenWidth,
            ),

            Gap(screenHeight * 0.03),

            announcementCard(
              "User Guidelines",
              "Keep our community safe and helpful",
              Icons.rule_rounded,
              AppColors.warning,
              () => {},
              screenWidth,
            ),

            Gap(screenHeight * 0.15),
          ],
        ),
      ),
    );
  }
}
