import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:UniStack/core/utils/app_colors.dart';

Widget emptyState(double screenWidth, bool isOwner) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: screenWidth * 0.2,
            color: Colors.grey.withOpacity(0.5),
          ),
          Gap(screenWidth * 0.05),

          Text(
            isOwner
                ? "No answers yet"
                : "No answers yet\nBe the first to help!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
          Gap(screenWidth * 0.02),

          Text(
            isOwner
                ? "We'll notify you once someone replies."
                : "Sharing your knowledge helps the community.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
