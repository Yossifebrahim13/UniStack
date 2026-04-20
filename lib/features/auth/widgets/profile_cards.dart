import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget profileCard({
  required double screenWidth,
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: screenWidth * 0.03,
      horizontal: screenWidth * 0.03,
    ),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        Gap(screenWidth * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}
