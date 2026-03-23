import 'package:UniStack/core/database/questions__store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:get/get.dart';

class MyQuestionsController extends GetxController {
  final QuestionsStore _questionStore = QuestionsStore.instance;

  final RxList<QuestionModel> _myQuestions = <QuestionModel>[].obs;
  List<QuestionModel> get myQuestions => _myQuestions.toList();

  @override
  void onInit() {
    super.onInit();
    getMyQuestions();
  }

  Future<void> getMyQuestions() async {
    try {
      final questions = await _questionStore.getMyQuestions();
      _myQuestions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }

  Future<void> deleteMyQuestion(String questionId) async {
    try {
      await _questionStore.deleteMyQuestion(questionId: questionId);
      _myQuestions.removeWhere((question) => question.id == questionId);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }

  Future<void> createQuestion(
    String title,
    String body,
    String category,
  ) async {
    try {
      await _questionStore.createQuestion(
        title: title,
        body: body,
        category: category,
      );
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }

  Future<void> editMyQuestion(QuestionModel question) async {
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
    }
  }
}
