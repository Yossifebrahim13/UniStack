import 'package:flutter/material.dart';
import 'package:UniStack/core/utils/app_colors.dart';

Widget statusChip(bool isAnswered, double screenWidth) {
  final color = isAnswered ? AppColors.success : AppColors.error;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      isAnswered ? "Solved" : "Pending",
      style: TextStyle(
        fontSize: screenWidth * 0.03,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
