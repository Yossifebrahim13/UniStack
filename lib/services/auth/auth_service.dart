import 'package:UniStack/core/error/error_handle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ========================= LOGIN ========================= ///
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null && !credential.user!.emailVerified) {
        await sendEmailVerification();
        await _auth.signOut();

        Get.snackbar(
          'Email Not Verified',
          'Please verify your email before logging in.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      ErrorHandel.handleAuthError(e);
    }
  }

  /// ========================= SIGN UP ========================= ///
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      ErrorHandel.handleAuthError(e);
    }
  }

  /// ========================= GOOGLE SIGN IN ========================= ///
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ========================= LOGOUT ========================= ///
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// ========================= EMAIL VERIFICATION ========================= ///
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();

      Get.snackbar(
        'Verification Email Sent',
        'Check your email (${user.email}) to verify your account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ========================= RESET PASSWORD ========================= ///
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ErrorHandel.handleAuthError(e);
    }
  }

  /// ========================= CURRENT USER ========================= ///
  User? getCurrentUser() => _auth.currentUser;
}
