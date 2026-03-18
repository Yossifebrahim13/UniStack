import 'package:UniStack/core/error/error_handle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await sendEmailVerification();
          await auth.signOut();

          Get.snackbar(
            'Email Not Verified',
            'Please verify your email before logging in.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      ErrorHandel.handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ========================= SIGN UP ========================= ///
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await user.updateDisplayName(fullName);

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

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

      final userCredential = await auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'fullName': user.displayName ?? '',
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
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
    await auth.signOut();
  }

  /// ========================= EMAIL VERIFICATION ========================= ///
  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;

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
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ErrorHandel.handleAuthError(e);
    }
  }

  /// ========================= CURRENT USER ========================= ///
  User? getCurrentUser() => auth.currentUser;
}
