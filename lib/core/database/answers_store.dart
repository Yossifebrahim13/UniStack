import 'package:UniStack/core/models/answer_model.dart';
import 'package:UniStack/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AnswersStore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AnswersStore get instance => Get.put(AnswersStore());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAnswer({
    required String questionId,
    required String body,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userName =
          userDoc.data()?['name'] ?? user.displayName ?? 'Anonymous';

      final WriteBatch batch = _firestore.batch();

      final questionRef = _firestore.collection('questions').doc(questionId);
      final answerRef = questionRef.collection('answers').doc(user.uid);
      final userRef = _firestore.collection('users').doc(user.uid);

      batch.set(answerRef, {
        'id': answerRef.id,
        'body': body,
        'userId': user.uid,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
        'isAccepted': false,
      });

      batch.update(questionRef, {'answersCount': FieldValue.increment(1)});

      batch.update(userRef, {
        'points': FieldValue.increment(10),
        'answersCount': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      print("Error adding answer: $e");
      rethrow;
    }
  }

  Future<void> acceptAnswer({
    required String questionId,
    required String answerId,
    required String questionOwnerId,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final questionRef = _firestore.collection('questions').doc(questionId);
        final answerRef = questionRef.collection('answers').doc(answerId);

        final answerDoc = await transaction.get(answerRef);
        if (!answerDoc.exists) return;

        final answerOwnerId = answerDoc.data()?['userId'];

        transaction.update(questionRef, {
          'acceptedAnswerId': answerId,
          'isAnswered': true,
        });

        transaction.update(answerRef, {'isAccepted': true});

        if (answerOwnerId != null) {
          final userRef = _firestore.collection('users').doc(answerOwnerId);
          transaction.update(userRef, {
            'points': FieldValue.increment(25),
            'bestAnswersCount': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      print("Firestore Error: $e");
    }
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
    try {
      final questionRef = _firestore.collection('questions').doc(questionId);
      final answerRef = questionRef.collection('answers').doc(answerId);

      final answerDoc = await answerRef.get();
      if (!answerDoc.exists) return;

      final bool isAccepted = answerDoc.data()?['isAccepted'] ?? false;
      final Map<String, dynamic> questionUpdates = {
        'answersCount': FieldValue.increment(-1),
      };

      if (isAccepted) {
        questionUpdates['isAnswered'] = false;
        questionUpdates['acceptedAnswerId'] = FieldValue.delete();
      }

      final int pointsToDeduct = isAccepted ? -35 : -10;

      final Map<String, dynamic> userUpdates = {
        'points': FieldValue.increment(pointsToDeduct),
        'answersCount': FieldValue.increment(-1),
      };

      if (isAccepted) {
        userUpdates['bestAnswersCount'] = FieldValue.increment(-1);
      }
      final WriteBatch batch = _firestore.batch();

      batch.update(questionRef, questionUpdates);
      batch.update(
        _firestore.collection('users').doc(answerOwnerId),
        userUpdates,
      );
      batch.delete(answerRef);

      await batch.commit();

      print("Answer deleted successfully and points updated.");
    } catch (e) {
      print("Error deleting answer: $e");
      rethrow;
    }
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
