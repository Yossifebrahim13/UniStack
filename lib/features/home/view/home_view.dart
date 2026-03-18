import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.offAllNamed(AppRoutes.login);
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
