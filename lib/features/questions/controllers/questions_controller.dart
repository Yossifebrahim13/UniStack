import 'package:UniStack/core/database/questions__store.dart';
import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  static QuestionsController get instance => Get.find();

  final _questionStore = QuestionsStore.instance;

  final RxList<QuestionModel> _questions = <QuestionModel>[].obs;
  List<QuestionModel> get questions => _questions;

  Future<void> getQuestions() async {
    try {
      final questions = await _questionStore.getQuestions();
      _questions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }

  Future<void> getQuestionsByCategory(String category) async {
    try {
      final questions = await _questionStore.getQuestionsByCategory(category);
      _questions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }

  Future<void> getQuestionsBySearch(String query) async {
    try {
      final questions = await _questionStore.getQuestionsBySearch(query);
      _questions.assignAll(questions);
    } catch (e) {
      ErrorHandle.handleError(e as Exception);
    }
  }
}
