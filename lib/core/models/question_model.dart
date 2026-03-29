import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final String userId;
  final String userName;
  final DateTime createdAt;

  final int answersCount;
  final String? acceptedAnswerId;
  final bool isAnswered;

  QuestionModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.userId,
    required this.userName,
    required this.createdAt,
    this.answersCount = 0,
    this.acceptedAnswerId,
    this.isAnswered = false,
  });

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      answersCount: data['answersCount'] ?? 0,
      acceptedAnswerId: data['acceptedAnswerId'],
      isAnswered: data['isAnswered'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt,
      'answersCount': answersCount,
      'acceptedAnswerId': acceptedAnswerId,
      'isAnswered': isAnswered,
    };
  }
}
