import 'package:UniStack/core/models/answer_model.dart';
import 'package:UniStack/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AnswersStore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AnswersStore get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAnswer({
    required String questionId,
    required String body,
  }) async {
    final user = _auth.currentUser!;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    final userModel = UserModel.fromFirestore(userDoc);

    final questionRef = _firestore.collection('questions').doc(questionId);

    await questionRef.collection('answers').add({
      'body': body,
      'userId': userModel.id,
      'userName': userModel.name,
      'createdAt': FieldValue.serverTimestamp(),
      'isAccepted': false,
    });

    await questionRef.update({'answersCount': FieldValue.increment(1)});

    await _firestore.collection('users').doc(user.uid).update({
      'points': FieldValue.increment(10),
      'answersCount': FieldValue.increment(1),
    });
  }

  Future<void> acceptAnswer({
    required String questionId,
    required String answerId,
    required String questionOwnerId,
  }) async {
    final questionRef = _firestore.collection('questions').doc(questionId);

    await questionRef.update({
      'acceptedAnswerId': answerId,
      'isAnswered': true,
    });

    await questionRef.collection('answers').doc(answerId).update({
      'isAccepted': true,
    });

    await _firestore.collection('users').doc(questionOwnerId).update({
      'points': FieldValue.increment(25),
    });
  }

  Stream<List<AnswerModel>> getAnswers(String questionId) {
    return _firestore
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AnswerModel.fromFirestore(doc);
          }).toList();
        });
  }

  Future<void> deleteAnswer({
    required String questionId,
    required String answerId,
    required String answerOwnerId,
  }) async {
    final questionRef = _firestore.collection('questions').doc(questionId);

    await questionRef.collection('answers').doc(answerId).delete();

    await questionRef.update({'answersCount': FieldValue.increment(-1)});

    await _firestore.collection('users').doc(answerOwnerId).update({
      'points': FieldValue.increment(-10),
      'answersCount': FieldValue.increment(-1),
    });
  }

  Future<void> editAnswer({
    required String questionId,
    required String answerId,
    required String newBody,
  }) async {
    final questionRef = _firestore.collection('questions').doc(questionId);

    await questionRef.collection('answers').doc(answerId).update({
      'body': newBody,
    });
  }
}
