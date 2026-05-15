import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final int points;

  final int questionsCount;
  final int answersCount;
  final int bestAnswersCount;
  final String? fcmToken;

  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.points = 0,
    this.questionsCount = 0,
    this.answersCount = 0,
    this.bestAnswersCount = 0,
    this.fcmToken,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      points: data['points'] ?? 0,
      questionsCount: data['questionsCount'] ?? 0,
      answersCount: data['answersCount'] ?? 0,
      bestAnswersCount: data['bestAnswersCount'] ?? 0,
      fcmToken: data['fcmToken'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'points': points,
      'questionsCount': questionsCount,
      'answersCount': answersCount,
      'bestAnswersCount': bestAnswersCount,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
    };
  }
}
