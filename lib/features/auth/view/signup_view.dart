import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:UniStack/features/auth/widgets/auth_btn.dart';
import 'package:UniStack/features/auth/widgets/auth_field.dart';
import 'package:UniStack/features/auth/widgets/auth_lable.dart';
import 'package:UniStack/features/auth/widgets/google_btn.dart';
import 'package:UniStack/shared/widgets/capy_rights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: AppColors.scaffold),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "lib/core/assets/img/applogo.jpeg",
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(screenWidth * 0.02),
                      const Text(
                        "UniStack",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Gap(screenWidth * 0.1),
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 36,
                      letterSpacing: -1,
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  const Text(
                    "Join the university community and start collaborating.",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  Gap(screenWidth * 0.1),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textSecondary.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authLabel("Full Name", screenWidth),
                          AuthField(
                            controller: authController.fullNameController,
                            hintText: "John Doe",
                            icon: Icons.person,
                            isPass: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          Gap(screenWidth * 0.05),
                          authLabel("Email Address", screenWidth),
                          AuthField(
                            controller: authController.emailController,
                            hintText: "j.doe@university.edu",
                            icon: Icons.email,
                            isPass: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          Gap(screenWidth * 0.05),
                          authLabel("Password", screenWidth),
                          AuthField(
                            controller: authController.passwordController,
                            hintText: "********",
                            icon: Icons.lock,
                            isPass: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          Gap(screenWidth * 0.07),
                          Obx(() => AuthBtn(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authController.signUp();
                              }
                            },
                            text: authController.isLoading.value
                                ? "Creating Account..."
                                : "Create Account",
                            isLoading: authController.isLoading.value,
                          )),
                          Gap(screenWidth * 0.07),
                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          Gap(screenWidth * 0.05),
                          Obx(() => googleBtn(
                            screenHeight, 
                            screenWidth, 
                            authController.signInWithGoogle,
                            isLoading: authController.isGoogleLoading.value,
                          )),
                        ],
                      ),
                    ),
                  ),
                  Gap(screenWidth * 0.07),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(AppRoutes.login);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(screenWidth * 0.01),
                  capyRights(),
                  Gap(screenWidth * 0.01),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
