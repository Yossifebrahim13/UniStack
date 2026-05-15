import 'package:UniStack/features/answers/controllers/answer_controller.dart';
import 'package:get/get.dart';

/// Registers [AnswerController] only for the `/answers` route.
/// Using a dedicated binding (instead of RootBinding) ensures the controller
/// is created fresh on every navigation and properly disposed when the user
/// navigates away — preventing stale Firestore listeners.
class AnswerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnswerController>(() => AnswerController());
  }
}
