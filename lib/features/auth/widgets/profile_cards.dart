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
    width: screenWidth * 0.37,
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [color.withOpacity(0.15), AppColors.card],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Floating Icon
        Container(
          padding: EdgeInsets.all(screenWidth * 0.025),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: screenWidth * 0.06),
        ),

        Gap(screenWidth * 0.03),

        // Value
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.065,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        Gap(screenWidth * 0.01),

        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
            color: AppColors.textPrimary.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
