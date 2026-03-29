import 'package:UniStack/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserStore {
  static UserStore get instance => Get.put(UserStore());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getUserPoints() async {
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    return userDoc['points'];
  }

  Future<int> getUserRank() async {
    final snapshot = await _firestore.collection('users').get();
    final users = snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
    users.sort((a, b) => b.points.compareTo(a.points));
    return users.indexWhere((user) => user.id == _auth.currentUser!.uid) + 1;
  }

  Future<int> getUserQuestionsCount() async {
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    return userDoc['questionsCount'];
  }

  Future<int> getUserAnswersCount() async {
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    return userDoc['answersCount'];
  }

  Future<void> updatePoints(int points) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'points': points,
    });
  }

  Future<void> updateRank(int rank) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'rank': rank,
    });
  }

  Future<void> updateQuestionsCount(int questionsCount) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'questionsCount': questionsCount,
    });
  }

  Future<void> updateAnswersCount(int answersCount) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'answersCount': answersCount,
    });
  }
}
