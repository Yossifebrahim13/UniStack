import 'package:UniStack/core/models/user_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:UniStack/services/notifications/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/database/user_store.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final UserStore userStore = UserStore.instance;

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final Rxn<User> firebaseUser = Rxn<User>();

  final RxInt points = 0.obs;
  final RxInt correctAnswers = 0.obs;
  final RxInt answersCount = 0.obs;
  final RxInt questionsCount = 0.obs;
  final RxInt rank = 0.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(AuthService.instance.auth.authStateChanges());

    ever(firebaseUser, (_) => loadUserStats());
  }

  Future<void> loadUserStats() async {
    if (currentUser != null) {
      points.value = await getUserPoints();
      correctAnswers.value = await getUserCorrectAnswers();
      answersCount.value = await getUserAnswersCount();
      questionsCount.value = await getUserQuestionsCount();
      rank.value = await getUserRank();
    }
  }

  /// ========================= GET USER STATS ========================= ///
  Future<int> getUserCorrectAnswers() async {
    return userStore.getUserCorrectAnswers();
  }

  Future<int> getUserAnswersCount() async {
    return userStore.getUserAnswersCount();
  }

  Future<int> getUserPoints() async {
    return userStore.getUserPoints();
  }

  Future<int> getUserQuestionsCount() async {
    return userStore.getUserQuestionsCount();
  }

  Future<int> getUserRank() async {
    return userStore.getUserRank();
  }

  /// ========================= SIGN UP ========================= ///
  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
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
        'Account created successfully',
        backgroundColor: AppColors.success,
        colorText: AppColors.card,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// ========================= LOGIN ========================= ///
  Future<UserModel?> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return null;
    }

    try {
      isLoading.value = true;

      final userModel = await AuthService.instance.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (AuthService.instance.getCurrentUser() != null) {
        // Save FCM token to Firestore after successful login
        await FcmService.instance.saveToken();
        Get.snackbar(
          'Success',
          'Logged in successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.card,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  /// ========================= GOOGLE SIGN IN ========================= ///
  Future<void> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      await AuthService.instance.signInWithGoogle();
      // Save FCM token to Firestore after Google sign-in
      await FcmService.instance.saveToken();
      Get.offAllNamed(AppRoutes.root);
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  /// ========================= LOGOUT ========================= ///
  Future<void> logout() async {
    // Clear FCM token from Firestore so no notifications are sent after logout
    await UserStore.instance.updateFcmToken('');
    // Unsubscribe from global topic
    await FcmService.instance.unsubscribeFromAllNotifications();
    await AuthService.instance.logout();
    Get.snackbar('Logged out', 'You have been logged out');
    Get.offAllNamed(AppRoutes.login);
  }

  /// ========================= RESET PASSWORD ========================= ///
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email required',
        backgroundColor: AppColors.error,
        colorText: AppColors.card,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      await AuthService.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset sent',
        backgroundColor: AppColors.success,
        colorText: AppColors.card,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// ========================= UPDATE USER NAME ========================= ///
  Future<void> updateUserName(String name) async {
    if (name.isEmpty) {
      Get.snackbar('Error', 'Username required');
      return;
    }
    try {
      isLoading.value = true;

      final user = currentUser;

      // update firestore
      await userStore.updateUserName(name);

      await user?.updateDisplayName(name);
      await user?.reload();

      firebaseUser.value = AuthService.instance.auth.currentUser;

      Get.snackbar(
        'Success',
        'Username updated successfully',
        backgroundColor: AppColors.success,
        colorText: AppColors.card,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } on Exception catch (e) {
      ErrorHandle.handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// ========================= GET CURRENT USER ========================= ///
  User? get currentUser => firebaseUser.value;
}
