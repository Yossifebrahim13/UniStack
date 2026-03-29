import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget infoCard({
  required String title,
  required String value,
  required IconData icon,
  required double screenWidth,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary),

        Gap(screenWidth * 0.03),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
