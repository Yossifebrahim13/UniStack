import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;

    return Container(
      width: screenWidth * 0.35,
      height: screenWidth * 0.20,
      margin: EdgeInsets.only(right: screenWidth * 0.03),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.06,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: AppColors.textSecondary,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Value
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.09,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
