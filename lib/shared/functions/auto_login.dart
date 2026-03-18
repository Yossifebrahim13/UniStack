import 'dart:async';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

StreamSubscription<User?>? _authSub;

void autoLogin() {
  _authSub?.cancel();

  _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
    try {
      if (user != null) {
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null && refreshedUser.emailVerified) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.login);
    }
  });
}
