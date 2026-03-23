import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:UniStack/core/error/error_handle.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final Rxn<User> firebaseUser = Rxn<User>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(AuthService.instance.auth.authStateChanges());
  }

  /// ========================= SIGN UP ========================= ///
  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      isLoading.value = true;

      await AuthService.instance.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      Get.snackbar(
        'Success',
        'Account created successfully. Check your email for verification.',
      );
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// ========================= LOGIN ========================= ///
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email & Password are required');
      return;
    }

    try {
      isLoading.value = true;

      await AuthService.instance.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (AuthService.instance.getCurrentUser() != null) {
        Get.snackbar('Success', 'Logged in successfully');
      }
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// ========================= GOOGLE SIGN IN ========================= ///
  Future<void> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      await AuthService.instance.signInWithGoogle();
      Get.snackbar('Success', 'Logged in with Google successfully');
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  /// ========================= LOGOUT ========================= ///
  Future<void> logout() async {
    await AuthService.instance.logout();
    Get.snackbar('Logged out', 'You have been logged out');
    Get.offAllNamed(AppRoutes.login);
  }

  /// ========================= RESET PASSWORD ========================= ///
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }

    try {
      await AuthService.instance.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    }
  }

  /// ========================= GET CURRENT USER ========================= ///
  User? get currentUser => firebaseUser.value;
}
