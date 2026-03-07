import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UniStack());
}

class UniStack extends StatefulWidget {
  const UniStack({super.key});

  @override
  State<UniStack> createState() => _UniStackState();
}

class _UniStackState extends State<UniStack> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onBoarding,
      getPages: AppRoutes.pages,
    );
  }
}
