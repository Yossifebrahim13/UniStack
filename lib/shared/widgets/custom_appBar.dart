import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.screenWidth,
    this.showBackButton = true,
    this.showLogoutButton = true,
  });
  final double screenWidth;
  final bool showBackButton;
  final bool showLogoutButton;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return AppBar(
      backgroundColor: AppColors.scaffold,
      elevation: 0,
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: screenWidth * 0.06,
              ),
              onPressed: () => Get.offNamed(AppRoutes.root),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenWidth * 0.02,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "lib/core/assets/img/applogo.jpeg",
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                fit: BoxFit.cover,
              ),
            ),
            Gap(screenWidth * 0.02),
            Text(
              "UniStack",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: showLogoutButton
          ? [
              IconButton(
                icon: Icon(
                  Icons.logout_sharp,
                  color: AppColors.textSecondary,
                  size: screenWidth * 0.07,
                ),
                onPressed: () => controller.logout(),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
