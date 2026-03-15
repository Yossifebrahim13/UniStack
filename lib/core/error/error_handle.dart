import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ErrorHandel {
  static void handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        Get.snackbar(
          'User Not Found',
          'No user found for that email.',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'wrong-password':
        Get.snackbar(
          'Wrong Password',
          'Incorrect password for that email.',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      default:
        Get.snackbar(
          'Error',
          e.message ?? 'An unknown error occurred.',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }
}
