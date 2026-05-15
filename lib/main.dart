import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/services/notifications/answer_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'package:UniStack/services/notifications/local_notification_service.dart';
import 'package:UniStack/services/notifications/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //  Local notifications (must be before FCM so the tap callback is ready)
  await LocalNotificationService.instance.init();

  // FCM
  await FcmService.instance.init();

  Get.put(AnswerNotificationService(), permanent: true);

  // Lock orientation
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
