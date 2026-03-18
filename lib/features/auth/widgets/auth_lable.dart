import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget authLabel(String text, double screenWidth) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8, left: screenWidth * 0.02),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.04,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
