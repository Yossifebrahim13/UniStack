import 'package:UniStack/features/answers/controllers/answer_controller.dart';
import 'package:UniStack/features/home/controllers/home_controller.dart';
import 'package:UniStack/features/myQuestions/controllers/myQuestion_controller.dart';
import 'package:UniStack/features/questions/controllers/questions_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyQuestionsController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => QuestionsController(), fenix: true);
    Get.lazyPut(() => AnswerController(), fenix: true);
  }
}
