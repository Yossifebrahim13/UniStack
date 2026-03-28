// دي ميثود بنادي عليها تبعتلي "ويدجت" كارت جاهز
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
Widget buildStatCard(String title, String value, String unit, IconData icon, Color iconColor) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 28),
        const Gap(12),
        Text(
          title, 
          style: const TextStyle(
            color: AppColors.textSecondary, 
            fontSize: 14
          )
        ),
        const Gap(5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value, 
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22, 
                fontWeight: FontWeight.bold
              )
            ),
            const Gap(4),
            Text(
              unit, 
              style: const TextStyle(
                color: AppColors.primary, 
                fontSize: 12,
                fontWeight: FontWeight.w600
              )
            ),
          ],
        ),
      ],
    ),
  );
}