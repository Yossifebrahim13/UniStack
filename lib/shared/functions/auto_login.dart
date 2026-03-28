import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

void handleAuthState() {
  FirebaseAuth.instance.authStateChanges().listen((user) async {
    if (user == null) {
      _goToLogin();
      return;
    }

    if (user.emailVerified) {
      _goToRoot();
    } else {
      _goToLogin();
    }
  });
}

void _goToLogin() {
  Future.microtask(() => Get.offAllNamed(AppRoutes.login));
}

void _goToRoot() {
  Future.microtask(() => Get.offAllNamed(AppRoutes.root));
}
