import 'package:UniStack/core/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      initialRoute: AppRoutes.splash,

      getPages: AppRoutes.pages,
    );
  }
}
