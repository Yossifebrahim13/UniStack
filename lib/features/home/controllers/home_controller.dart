import 'package:UniStack/core/database/user_store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/services/auth/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  static HomeController get instance => Get.find();

  final RxInt _points = 0.obs;
  int get points => _points.value;

  final RxInt _rank = 0.obs;
  int get rank => _rank.value;

  final RxInt _questionsCount = 0.obs;
  int get questionsCount => _questionsCount.value;

  final RxInt _answersCount = 0.obs;
  int get answersCount => _answersCount.value;

  @override
  void onInit() {
    super.onInit();
    getStats();
  }

  Future<void> getStats() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      final user = AuthService.instance.auth.currentUser;
      if (user != null) {
        _points.value = await UserStore.instance.getUserPoints();
        _rank.value = await UserStore.instance.getUserRank();
        _questionsCount.value = await UserStore.instance
            .getUserQuestionsCount();
        _answersCount.value = await UserStore.instance.getUserAnswersCount();
      }
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }
}
