import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/widgets/dot_indecator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int pageIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "lottie": "lib/core/assets/animations/Thinking (People also ask).json",
      "title": "Ask Your Questions",
      "subtitle":
          "Stuck on a topic? Ask your question and get help from other students.",
    },
    {
      "lottie": "lib/core/assets/animations/About Us Team.json",
      "title": "Learn From Others",
      "subtitle":
          "Explore answers shared by students and discover new ways to solve problems.",
    },
    {
      "lottie": "lib/core/assets/animations/Share creativity, share idea.json",
      "title": "Share Your Knowledge",
      "subtitle":
          "Help your classmates by answering their questions and grow together.",
    },
  ];

  void nextPage() {
    if (pageIndex == pages.length - 1) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppSizes(context).screenHeight;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.scaffold, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              /// Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) {
                    setState(() => pageIndex = i);
                  },
                  itemCount: pages.length,
                  itemBuilder: (_, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Animation
                        SizedBox(
                          height: screenHeight * 0.32,
                          child: Lottie.asset(pages[i]['lottie']),
                        ),

                        Gap(screenHeight * 0.04),

                        /// Text Card
                        Container(
                          width: screenWidth * 0.85,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                pages[i]['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              Gap(screenHeight * 0.015),

                              Text(
                                pages[i]['subtitle'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.017,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Indicator
              Dotindecator(pages: pages, pageIndex: pageIndex),

              Gap(screenHeight * 0.03),

              /// Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 6,
                    ),
                    onPressed: nextPage,
                    child: Text(
                      pageIndex == pages.length - 1 ? "Get Started" : "Next",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Gap(screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
