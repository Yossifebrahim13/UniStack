import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget quickActionsCard(IconData icon , String title , VoidCallback onTap ){
  return GestureDetector(
    onTap: onTap,
    child: Container(
             decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 36 , vertical:20 ),
            child: Column(
              children: [
                Icon(icon),
                Gap(10),
                Text(title)
              ],
            ),
          ),
        ),
  );
}