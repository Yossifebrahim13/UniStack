import 'package:UniStack/core/error/error_handle.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class QuestionsStore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static QuestionsStore get instance => Get.put(QuestionsStore());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createQuestion({
    required String title,
    required String body,
    required String category,
  }) async {
    final user = _auth.currentUser!;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    final userModel = UserModel.fromFirestore(userDoc);

    await _firestore.collection('questions').add({
      'title': title,
      'body': body,
      'category': category,
      'userId': userModel.id,
      'userName': userModel.name,
      'createdAt': FieldValue.serverTimestamp(),
      'answersCount': 0,
      'isAnswered': false,
      'acceptedAnswerId': null,
    });

    await _firestore.collection('users').doc(user.uid).update({
      'points': FieldValue.increment(5),
      'questionsCount': FieldValue.increment(1),
    });
  }

  Future<void> deleteMyQuestion({required String questionId}) async {
    final user = _auth.currentUser!;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    final userModel = UserModel.fromFirestore(userDoc);

    final questionDoc = await _firestore
        .collection('questions')
        .doc(questionId)
        .get();

    final questionModel = QuestionModel.fromFirestore(questionDoc);

    if (questionModel.userId != userModel.id) {
      ErrorHandle.handleError(
        Exception('You are not authorized to delete this question'),
      );
      return;
    }

    await _firestore.collection('questions').doc(questionId).delete();

    await _firestore.collection('users').doc(userModel.id).update({
      'points': FieldValue.increment(-10),
      'questionsCount': FieldValue.increment(-1),
    });
  }

  Future<void> editQuestion({
    required String questionId,
    required String newTitle,
    required String newBody,
    required String newCategory,
  }) async {
    final user = _auth.currentUser!;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    final userModel = UserModel.fromFirestore(userDoc);

    final questionDoc = await _firestore
        .collection('questions')
        .doc(questionId)
        .get();

    final questionModel = QuestionModel.fromFirestore(questionDoc);

    if (questionModel.userId != userModel.id) {
      ErrorHandle.handleError(
        Exception('You are not authorized to edit this question'),
      );
      return;
    }

    await _firestore.collection('questions').doc(questionId).update({
      'title': newTitle,
      'body': newBody,
      'category': newCategory,
    });
  }

  Future<List<QuestionModel>> getQuestions() async {
    final snapshot = await _firestore.collection('questions').get();
    return snapshot.docs
        .map((doc) => QuestionModel.fromFirestore(doc))
        .toList();
  }

  Future<List<QuestionModel>> getQuestionsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs
        .map((doc) => QuestionModel.fromFirestore(doc))
        .toList();
  }

  Future<List<QuestionModel>> getMyQuestions() async {
    final snapshot = await _firestore
        .collection('questions')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .get();
    return snapshot.docs
        .map((doc) => QuestionModel.fromFirestore(doc))
        .toList();
  }

  Future<List<QuestionModel>> getQuestionsBySearch(String query) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('title', isEqualTo: query)
        .get();
    return snapshot.docs
        .map((doc) => QuestionModel.fromFirestore(doc))
        .toList();
  }
}
