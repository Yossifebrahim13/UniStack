import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget capyRights() {
  return Center(
    child: Text(
      "© 2026 UniStack Platform. All rights reserved by YAM Team",
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
      ),
    ),
  );
}
