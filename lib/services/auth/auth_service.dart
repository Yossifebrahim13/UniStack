import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/user_model.dart';
import 'package:UniStack/core/utils/pref_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      await PrefHelpers.clearUserId();
      await PrefHelpers.saveUserId(user.uid);
      final userModel = UserModel.fromFirestore(userDoc);
      if (!user.emailVerified) {
        await sendEmailVerification();
        await auth.signOut();

        Get.snackbar(
          'Email Not Verified',
          'Please verify your email before logging in.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
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

        final userModel = UserModel(
          id: user.uid,
          name: fullName,
          email: email,
          points: 0,
          questionsCount: 0,
          answersCount: 0,
          bestAnswersCount: 0,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestore(), SetOptions(merge: true));
      }

      await sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      ErrorHandle.handleAuthError(e);
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
        await PrefHelpers.clearUserId();
        await PrefHelpers.saveUserId(user.uid);
        if (!doc.exists) {
          final userModel = UserModel(
            id: user.uid,
            name: user.displayName ?? 'anonymous',
            email: user.email ?? '',
            createdAt: DateTime.now(),
            points: 0,
            questionsCount: 0,
            answersCount: 0,
            bestAnswersCount: 0,
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toFirestore(), SetOptions(merge: true));
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
    await PrefHelpers.clearUserId();
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
      ErrorHandle.handleAuthError(e);
    }
  }

  /// ========================= CURRENT USER ========================= ///
  User? getCurrentUser() => auth.currentUser;
}
