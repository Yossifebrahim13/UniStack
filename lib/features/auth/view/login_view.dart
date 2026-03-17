import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/auth/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    Gap(screenHeight * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Sign in",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.05),
                    Center(child: Text("or continue with google")),
                    Gap(screenHeight * 0.02),
                    SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            "lib/core/assets/img/google_icon.png",
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Sign in with Google"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?"),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign UP",
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
