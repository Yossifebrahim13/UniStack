import 'package:UniStack/core/database/questions__store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:get/get.dart';

class MyQuestionsController extends GetxController {
  final QuestionsStore _questionStore = QuestionsStore.instance;
  final RxBool isLoading = false.obs;

  final RxList<QuestionModel> _myQuestions = <QuestionModel>[].obs;
  List<QuestionModel> get myQuestions => _myQuestions.toList();
  final RxList<QuestionModel> _filteredQuestions = <QuestionModel>[].obs;

  List<QuestionModel> get filteredQuestions => _filteredQuestions.toList();

  @override
  void onInit() {
    super.onInit();
    getMyQuestions();
  }

  Future<void> getMyQuestions() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      final questions = await _questionStore.getMyQuestions();
      _myQuestions.assignAll(questions);
      _filteredQuestions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMyQuestion(String questionId) async {
    isLoading.value = true;
    try {
      await _questionStore.deleteMyQuestion(questionId: questionId);
      _myQuestions.removeWhere((question) => question.id == questionId);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createQuestion(
    String title,
    String body,
    String category,
  ) async {
    isLoading.value = true;
    try {
      await _questionStore.createQuestion(
        title: title,
        body: body,
        category: category,
      );
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editMyQuestion(QuestionModel question) async {
    isLoading.value = true;
    try {
      await _questionStore.editQuestion(
        questionId: question.id,
        newTitle: question.title,
        newBody: question.body,
        newCategory: question.category,
      );
      _myQuestions.removeWhere((q) => q.id == question.id);
      _myQuestions.add(question);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  void searchQuestions(String query) {
    if (query.isEmpty) {
      _filteredQuestions.assignAll(_myQuestions);
      return;
    }

    final filtered = _myQuestions.where((question) {
      final q = query.toLowerCase();
      return question.title.toLowerCase().startsWith(q) ||
          question.body.toLowerCase().startsWith(q) ||
          question.category.toLowerCase().startsWith(q);
    }).toList();

    _filteredQuestions.assignAll(filtered);
  }
}
