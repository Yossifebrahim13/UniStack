import 'dart:async';

import 'package:UniStack/core/database/answers_store.dart';
import 'package:UniStack/core/database/questions__store.dart';
import 'package:UniStack/core/models/answer_model.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/pref_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AnswerController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AnswersStore _answersStore = AnswersStore.instance;

  // ── Reactive state ─────────────────────────────────────────────────────────

  final RxString userId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isOwner = false.obs;

  final RxList<AnswerModel> answers = <AnswerModel>[].obs;
  final RxList<AnswerModel> bestAnswers = <AnswerModel>[].obs;

  final Rxn<QuestionModel> currentQuestion = Rxn<QuestionModel>();

  // ── Private ────────────────────────────────────────────────────────────────

  StreamSubscription<QuerySnapshot>? _answerSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();

    final args = Get.arguments;
    if (args is QuestionModel) {
      currentQuestion.value = args;
      getAnswers(args.id);
    } else if (args is String) {
      _loadQuestionById(args);
      getAnswers(args);
    }
  }

  @override
  void onClose() {
    _answerSubscription?.cancel();
    super.onClose();
  }

  // ── User ID ────────────────────────────────────────────────────────────────

  Future<void> _loadUserId() async {
    isOwner.value = true;
    String storedId = await PrefHelpers.getUserId();
    if (storedId.isEmpty && auth.currentUser != null) {
      storedId = auth.currentUser!.uid;
      await PrefHelpers.saveUserId(storedId);
    }
    userId.value = storedId;
    isOwner.value = false;
  }

  // ── Fetch question by ID (notification-tap path) ───────────────────────────

  Future<void> _loadQuestionById(String questionId) async {
    try {
      final q = await QuestionsStore.instance.getQuestionById(questionId);
      if (q != null) currentQuestion.value = q;
    } catch (e) {
      debugPrint('[AnswerController] Failed to fetch question $questionId: $e');
    }
  }

  Future<void> getAnswers(String questionId) async {
    isLoading.value = true;

    _answerSubscription?.cancel();

    _answerSubscription = _answersStore
        .getAnswersSnapshot(questionId)
        .listen(
          (snapshot) {
            final newAnswers = snapshot.docs
                .map((doc) => AnswerModel.fromFirestore(doc))
                .toList();
            answers.assignAll(newAnswers);
            bestAnswers.assignAll(newAnswers.where((a) => a.isAccepted));
            isLoading.value = false;
          },
          onError: (e) {
            isLoading.value = false;
            Get.snackbar('Error', e.toString());
          },
        );
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  Future<bool> addAnswer({
    required String questionId,
    required String body,
  }) async {
    try {
      if (answers.any((a) => a.userId == userId.value)) {
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
