import 'package:UniStack/core/database/questions__store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  static QuestionsController get instance => Get.find();

  final _questionStore = QuestionsStore.instance;
  final RxBool isLoading = false.obs;

  final RxList<QuestionModel> _questions = <QuestionModel>[].obs;
  List<QuestionModel> get questions => _questions;
  final RxList<QuestionModel> _filteredQuestions = <QuestionModel>[].obs;

  List<QuestionModel> get filteredQuestions => _filteredQuestions.toList();

  @override
  void onInit() {
    getQuestions();
    super.onInit();
  }

  Future<void> getQuestions() async {
    try {
      isLoading.value = true;
      final questions = await _questionStore.getQuestions();
      _questions.assignAll(questions);
      _filteredQuestions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getQuestionsBySearch(String query) async {
    isLoading.value = true;
    try {
      if (query.isEmpty) {
        _filteredQuestions.assignAll(_questions);
      } else {
        final questions = _questions
            .where(
              (question) =>
                  question.title.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ) ||
                  question.body.toLowerCase().startsWith(query.toLowerCase()) ||
                  question.category.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
        _filteredQuestions.assignAll(questions);
      }
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }
}
