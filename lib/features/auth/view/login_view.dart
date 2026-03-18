import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/widgets/auth_field.dart';
import 'package:UniStack/features/auth/widgets/google_btn.dart';
import 'package:UniStack/features/auth/widgets/auth_btn.dart';
import 'package:UniStack/features/auth/controllers/auth_controller.dart';
import 'package:UniStack/shared/widgets/capy_rights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppSizes(context).screenHeight;
    final screenWidth = AppSizes(context).screenWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Gap(screenHeight * 0.1),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "lib/core/assets/img/applogo.jpeg",
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: const Text(
                  "UniStack",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Center(child: const Text("Learn, Ask , Share")),
              Gap(screenHeight * 0.05),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Gap(screenHeight * 0.01),
                      const Text(
                        "Enter your credentials to access your account",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Gap(screenHeight * 0.02),
                      const Text(
                        "Email",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      Gap(screenHeight * 0.01),
                      AuthField(
                        controller: authController.emailController,
                        hintText: "johndoe@examble",
                        icon: Icons.email,
                        isPass: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!value.contains("@")) {
                            return "Please enter a valid email";
                          }
                          if (!value.contains(".")) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      Gap(screenHeight * 0.02),
                      const Text(
                        "Password",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      Gap(screenHeight * 0.01),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              authController.resetPassword(
                                authController.emailController.text,
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.02),
                      Obx(
                        () => AuthBtn(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              authController.login();
                            }
                          },
                          text: authController.isLoading.value
                              ? "Logging in..."
                              : "Login",
                          isLoading: authController.isLoading.value,
                        ),
                      ),
                      Gap(screenHeight * 0.05),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.textPrimary,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.textPrimary,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.02),
                      Obx(
                        () => googleBtn(
                          screenHeight,
                          screenWidth,
                          authController.signInWithGoogle,
                          isLoading: authController.isGoogleLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?"),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.signUp);
                    },
                    child: Text(
                      "Sign UP",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              Gap(screenHeight * 0.01),
              capyRights(),
              Gap(screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
