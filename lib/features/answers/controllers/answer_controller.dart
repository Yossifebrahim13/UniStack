import 'package:UniStack/core/database/answers_store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/answer_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/pref_helpers.dart';
import 'package:UniStack/shared/widgets/glass_loader.dart';
import 'package:get/get.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnswerController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AnswersStore _answersStore = AnswersStore.instance;

  var userId = ''.obs;

  final RxList<AnswerModel> answers = <AnswerModel>[].obs;
  final RxList<AnswerModel> bestAnswers = <AnswerModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserId();
    final args = Get.arguments;
    if (args is QuestionModel) {
      getAnswers(args.id);
    } else if (args is String) {
      getAnswers(args);
    }
  }

  void loadUserId() async {
    isOwner.value = true;

    String storedId = await PrefHelpers.getUserId();

    if (storedId.isEmpty && auth.currentUser != null) {
      storedId = auth.currentUser!.uid;
      await PrefHelpers.saveUserId(storedId);
    }

    userId.value = storedId;
    isOwner.value = false;
  }

  Future<void> getAnswers(String questionId) async {
    try {
      isLoading.value = true;
      _answersStore.getAnswers(questionId).listen((answers) {
        this.answers.assignAll(answers);
        bestAnswers.assignAll(answers.where((answer) => answer.isAccepted));
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAnswer({
    required String questionId,
    required String body,
  }) async {
    try {
      bool alreadyAnswered = answers.any((a) => a.userId == userId.value);

      if (alreadyAnswered) {
        Get.snackbar(
          'Action Denied',
          'You have already provided an answer to this question.',
          backgroundColor: AppColors.warning,
          colorText: AppColors.card,
        );
        return false;
      }

      isLoading.value = true;
      await _answersStore.addAnswer(questionId: questionId, body: body);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptAnswer({
    required String questionId,
    required String answerId,
    required String questionOwnerId,
  }) async {
    try {
      isLoading.value = true;
      await _answersStore.acceptAnswer(
        questionId: questionId,
        answerId: answerId,
        questionOwnerId: questionOwnerId,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAnswer({
    required String questionId,
    required String answerId,
    required String answerOwnerId,
  }) async {
    try {
      answers.removeWhere((a) => a.id == answerId);

      isLoading.value = true;
      await _answersStore.deleteAnswer(
        questionId: questionId,
        answerId: answerId,
        answerOwnerId: answerOwnerId,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editAnswer({
    required String questionId,
    required String answerId,
    required String newBody,
  }) async {
    try {
      isLoading.value = true;
      await _answersStore.editAnswer(
        questionId: questionId,
        answerId: answerId,
        newBody: newBody,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
