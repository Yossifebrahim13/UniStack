import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget categoryChip(String category, double screenWidth) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      category.toUpperCase(),
      style: TextStyle(
        fontSize: screenWidth * 0.028,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1,
      ),
    ),
  );
}
