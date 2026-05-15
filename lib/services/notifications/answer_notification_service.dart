import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:UniStack/services/notifications/local_notification_service.dart';

class AnswerNotificationService extends GetxService {
  static AnswerNotificationService get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // One StreamSubscription per question's answers sub-collection.
  final Map<String, StreamSubscription<QuerySnapshot>> _answerSubs = {};

  // Top-level subscription that watches the user's questions list.
  StreamSubscription<QuerySnapshot>? _questionsSub;

  final Set<String> _notifiedAnswerIds = {};

  late final Timestamp _startedAt;

  @override
  void onInit() {
    super.onInit();
    _startedAt = Timestamp.now();

    // Automatically start/stop when the user logs in or out
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _start(user.uid);
      } else {
        _stop();
      }
    });

    debugPrint('[AnswerNotifService] Initialized — startedAt: $_startedAt');
  }

  @override
  void onClose() {
    _stop();
    super.onClose();
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  /// Begin watching the logged-in user's own questions, then subscribe
  /// to the answers of each one dynamically (handles add/remove of questions).
  void _start(String userId) {
    _stop(); // clean slate on re-login
    debugPrint('[AnswerNotifService] Starting for user $userId');

    _questionsSub = _firestore
        .collection('questions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            final liveIds = snapshot.docs.map((d) => d.id).toSet();

            // Subscribe to any questions we aren't watching yet.
            for (final qId in liveIds) {
              if (!_answerSubs.containsKey(qId)) {
                _subscribeToAnswers(qId, userId);
              }
            }

            // Unsubscribe from questions that were deleted.
            final stale = _answerSubs.keys.toSet().difference(liveIds);
            for (final qId in stale) {
              _answerSubs[qId]?.cancel();
              _answerSubs.remove(qId);
              debugPrint(
                '[AnswerNotifService] Unsubscribed from deleted Q: $qId',
              );
            }
          },
          onError: (e) =>
              debugPrint('[AnswerNotifService] Questions stream error: $e'),
        );
  }

  /// Subscribe to `questions/{questionId}/answers` and react to new docs.
  void _subscribeToAnswers(String questionId, String currentUserId) {
    debugPrint('[AnswerNotifService] Subscribing to answers → Q: $questionId');

    final sub = _firestore
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .snapshots()
        .listen(
          (snapshot) {
            for (final change in snapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                _handleNewAnswer(
                  doc: change.doc,
                  questionId: questionId,
                  currentUserId: currentUserId,
                );
              }
            }
          },
          onError: (e) => debugPrint(
            '[AnswerNotifService] Answers stream error (Q: $questionId): $e',
          ),
        );

    _answerSubs[questionId] = sub;
  }

  /// Decide whether to notify and, if so, fire the local notification.
  void _handleNewAnswer({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required String questionId,
    required String currentUserId,
  }) {
    final data = doc.data();
    if (data == null) return;

    final answerId = doc.id;
    final answerUserId = data['userId'] as String?;
    final createdAt = data['createdAt'] as Timestamp?;
    final raw = data['userName'] as String?;
    final userName = (raw != null && raw.trim().isNotEmpty)
        ? raw.trim()
        : 'Someone';

    if (answerUserId == currentUserId) return;
    if (createdAt != null && createdAt.compareTo(_startedAt) < 0) return;

    if (_notifiedAnswerIds.contains(answerId)) return;
    _notifiedAnswerIds.add(answerId);

    if (_notifiedAnswerIds.length > 500) {
      _notifiedAnswerIds.remove(_notifiedAnswerIds.first);
    }

    debugPrint(
      '[AnswerNotifService] → Notifying: A=$answerId Q=$questionId by $userName',
    );

    LocalNotificationService.instance.showLocalNotification(
      title: 'New Answer 💬',
      body: '$userName answered your question',
      questionId: questionId,
      dedupKey: answerId,
    );
  }

  void _stop() {
    _questionsSub?.cancel();
    _questionsSub = null;
    for (final sub in _answerSubs.values) {
      sub.cancel();
    }
    _answerSubs.clear();
    _notifiedAnswerIds.clear();
    debugPrint('[AnswerNotifService] All subscriptions stopped');
  }
}
