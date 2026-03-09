import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/pref_helpers.dart';
import 'package:get/get.dart';

void firstTimeCheck() {
  PrefHelpers().getFirstTime().then((value) {
    if (value) {
      Get.toNamed(AppRoutes.onBoarding);
    } else {
      Get.toNamed(AppRoutes.login);
    }
  });
}
