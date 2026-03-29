import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final String id;
  final String body;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final bool isAccepted;

  AnswerModel({
    required this.id,
    required this.body,
    required this.userId,
    required this.userName,
    required this.createdAt,
    this.isAccepted = false,
  });

  factory AnswerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnswerModel(
      id: doc.id,
      body: data['body'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isAccepted: data['isAccepted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'body': body,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt,
      'isAccepted': isAccepted,
    };
  }
}
