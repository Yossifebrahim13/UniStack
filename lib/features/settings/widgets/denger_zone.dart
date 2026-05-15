import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Widget dangerZone(
  BuildContext context,
  double screenHeight,
  double screenWidth,
) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.02,
    ),
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
            Text(
              "Danger Zone",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.warning, color: AppColors.error),
            ),
          ],
        ),

        Gap(screenHeight * 0.02),

        Text(
          "This action cannot be undone.",
          style: const TextStyle(color: AppColors.textSecondary),
        ),

        Gap(screenHeight * 0.02),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "This action cannot be undone.",
            style: const TextStyle(color: AppColors.error),
          ),
        ),

        Gap(screenHeight * 0.02),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            _showDeleteDialog(context, screenHeight, screenWidth);
          },
          child: Text(
            "Delete Account",
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
}

void _showDeleteDialog(
  BuildContext context,
  double screenHeight,
  double screenWidth,
) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete, color: AppColors.error, size: 40),
            Gap(screenHeight * 0.02),
            Text(
              "Are you sure?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Gap(screenHeight * 0.02),
            Text(
              "This action cannot be undone.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              AuthService.instance.deleteAccount();
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text(
              "Delete",
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      );
    },
  );
}
