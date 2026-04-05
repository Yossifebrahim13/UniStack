import 'dart:ui';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GlassLoader extends StatelessWidget {
  final String? message;

  const GlassLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: screenWidth * 0.4,
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              color: AppColors.loaderBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.loaderBackground.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.card,
                  strokeWidth: 3,
                ),
                if (message != null) ...[
                  Gap(screenHeight * 0.02),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.card,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
