import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ErrorHandle {
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
      case 'email-already-in-use':
        Get.snackbar(
          'Email Already In Use',
          'An account already exists with this email.',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case "The supplied auth credential is incorrect, malformed or has expired.":
        Get.snackbar(
          'Invalid Credential',
          'The supplied authentication secret was invalid.',
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

  static void handleError(Exception e) {
    Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}
