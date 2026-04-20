import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    return Scaffold(
      appBar: CustomAppBar(
        screenWidth: screenWidth,
        showBackButton: true,
        showLogoutButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Gap(screenHeight * 0.02),
            // Logo
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("lib/core/assets/img/applogo.jpeg"),
              ),
            ),
            Gap(screenHeight * 0.02),
            // App Name & Version
            const Text(
              'UniStack',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            Gap(screenHeight * 0.02),

            // Description Section
            _buildSectionTitle('What is UniStack?', screenHeight),
            const Text(
              'UniStack is a collaborative community for students to share knowledge. '
              'Ask questions, provide answers, and earn points as you help others grow. '
              'Built specifically to make learning more accessible and interactive.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            Gap(screenHeight * 0.03),

            // Features List
            _buildSectionTitle('Key Features', screenHeight),
            _buildFeatureItem(
              Icons.question_answer,
              'Ask & Answer questions easily.',
              screenWidth,
              screenHeight,
            ),
            _buildFeatureItem(
              Icons.stars,
              'Earn points for your contributions.',
              screenWidth,
              screenHeight,
            ),
            _buildFeatureItem(
              Icons.verified_user,
              'Secure and verified student profiles.',
              screenWidth,
              screenHeight,
            ),

            Gap(screenHeight * 0.04),

            // Footer
            const Divider(),
            const Text(
              'Made with YAM for students',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),

            Gap(screenHeight * 0.01),
            const Text(
              '© 2026 UniStack Team',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Gap(screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String text,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          Gap(screenWidth * 0.02),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
