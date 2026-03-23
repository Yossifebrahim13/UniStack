import 'dart:async';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

StreamSubscription<User?>? _authSub;

void autoLogin() {
  _authSub?.cancel();

  _authSub = FirebaseAuth.instance.idTokenChanges().listen((user) async {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      Get.offAllNamed(AppRoutes.root);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  });
}
