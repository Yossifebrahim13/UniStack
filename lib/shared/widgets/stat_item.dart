import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget statItem({
  required IconData icon,
  required String label,
  required double screenWidth,
}) {
  return Row(
    children: [
      Icon(icon, size: 16, color: AppColors.primary),
      Gap(screenWidth * 0.01),
      Text(
        label,
        style: TextStyle(
          fontSize: screenWidth * 0.03,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
