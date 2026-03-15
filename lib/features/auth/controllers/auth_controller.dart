import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService.instance;

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  set fullName(String value) {
    fullNameController.text = value;
  }

  set email(String value) {
    emailController.text = value;
  }

  set password(String value) {
    passwordController.text = value;
  }

  String get fullName => fullNameController.text.trim();
  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();

  Future<void> login() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      await _authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _authService.getCurrentUser();
      if (user != null && user.emailVerified) {
        Get.offAllNamed(AppRoutes.home);
      }
      if (user != null && !user.emailVerified) {
        Get.snackbar("Email Not Verified", "Please verify your email");
      }
    } catch (e) {
      Get.snackbar("Login Failed", "Please try again");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      await _authService.signInWithGoogle();
      final user = _authService.getCurrentUser();
      if (user != null && user.emailVerified) {
        Get.offAllNamed(AppRoutes.home);
      }
      if (user != null && !user.emailVerified) {
        Get.snackbar("Email Not Verified", "Please verify your email");
      }
    } catch (e) {
      Get.snackbar("Login Failed", "Please try again");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        "Sign Up Successful",
        "Verification link has been sent to your email : $email \n please verify your email to login ...",
      );
    } catch (e) {
      Get.snackbar("Sign Up Failed", "Please try again");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> resetPassword() async {
    await _authService.sendPasswordResetEmail(email: email);
    Get.snackbar(
      'Check Your Email',
      'Password reset link sent to $email',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
