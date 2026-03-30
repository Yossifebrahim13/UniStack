import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget googleBtn(
  double screenHeight,
  double screenWidth,
  VoidCallback onTap, {
  bool isLoading = false,
}) {
  return InkWell(
    onTap: isLoading ? null : onTap,
    child: Container(
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else ...[
            Image.asset(
              "lib/core/assets/img/google_icon.png",
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
            ),
            Gap(screenWidth * 0.02),
          ],
          Gap(screenWidth * 0.01),
          Text(
            "Sign in with Google",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ],
      ),
    ),
  );
}
