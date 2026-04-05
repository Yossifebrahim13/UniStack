import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final nameController = TextEditingController(
    text: AuthService.instance.auth.currentUser?.displayName ?? "",
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),
      body: Center(
        child: TextButton(
          onPressed: () {
            AuthService.instance.logout();
          },
          child: Text(
            "Logout",
            style: TextStyle(
              color: AppColors.error,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
      ),
    );
  }
}
