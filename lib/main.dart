import 'package:UniStack/core/error/error_controller.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NetworkController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const UniStack());
}

class UniStack extends StatelessWidget {
  const UniStack({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UniStack',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      getPages: AppRoutes.pages,
    );
  }
}
