import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/pref_helpers.dart';
import 'package:UniStack/shared/functions/auto_login.dart';
import 'package:get/get.dart';

Future<void> firstTimeCheck() async {
  bool isFirstTime = await PrefHelpers().getFirstTime();

  if (isFirstTime) {
    Get.offAllNamed(AppRoutes.onBoarding);
  } else {
    handleAuthState();
  }
}
