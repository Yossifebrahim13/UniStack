import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 80, color: AppColors.icon),
            const Gap(16),
            Text(
              "No Internet Connection 😢",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            Text(
              "Please check your internet connection 🔌",
              style: TextStyle(color: AppColors.icon, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
