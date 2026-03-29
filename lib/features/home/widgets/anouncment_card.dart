import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget announcementCard(
  String title,
  String description,
  IconData icon,
  Color iconColor,
  VoidCallback action,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryDark.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primaryDark.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: 30),
        const Gap(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: action,
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ],
    ),
  );
}
