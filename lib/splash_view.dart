import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // النقل لصفحة الأونبوردينج بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.onBoarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHight = AppSizes(context).screenHeight;
    final screenwidth = AppSizes(context).screenWidth;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أنيميشن اللوجو مع حماية الـ Opacity
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 2000),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOutBack,
              builder: (context, double value, child) {
                return Opacity(
                  // الـ clamp هنا عشان نمنع القيم اللي أكبر من 1 أو أقل من 0
                  opacity: value.clamp(0.0, 1.0), 
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: screenwidth * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "lib/core/assets/img/WhatsApp Image 2026-03-09 at 1.39.53 AM.jpeg",
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const Gap(40),

            // أنيميشن النص (Slide Up)
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 2000),
              tween: Tween<double>(begin: 40, end: 0),
              builder: (context, double offset, child) {
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: Column(
                children: [
                  Text(
                    "UniStack",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "THE Students HUB",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}