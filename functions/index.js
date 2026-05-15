/**
 * UniStack – Firebase Cloud Function (Production Ready)
 */

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();

// ─────────────────────────────────────────────────────────────
// Helper: shorten long text (better notification UX)
// ─────────────────────────────────────────────────────────────
function shorten(text, max = 40) {
  if (!text) return "";
  return text.length > max ? text.substring(0, max) + "..." : text;
}

// ─────────────────────────────────────────────────────────────
// Trigger
// ─────────────────────────────────────────────────────────────
exports.onNewAnswer = onDocumentCreated(
  "questions/{questionId}/answers/{answerId}",
  async (event) => {
    const { questionId, answerId } = event.params;
    const answerData = event.data?.data();

    if (!answerData) {
      console.log("No answer data found.");
      return;
    }

    const answerAuthorId = answerData.userId;
    const answerAuthorName = answerData.userName ?? "Someone";

    // ── 1. Fetch question ─────────────────────────────────────
    const questionRef = db.collection("questions").doc(questionId);
    const questionSnap = await questionRef.get();

    if (!questionSnap.exists) {
      console.log(`Question ${questionId} not found.`);
      return;
    }

    const questionData = questionSnap.data();
    const questionOwnerId = questionData.userId;
    const questionTitle = shorten(questionData.title, 45);

    // ── 2. Skip self-answer ───────────────────────────────────
    if (answerAuthorId === questionOwnerId) {
      console.log("Owner answered their own question.");
      return;
    }

    // ── 3. Rate limiting (anti-spam) ─────────────────────────
    const metaRef = db
      .collection("users")
      .doc(questionOwnerId)
      .collection("meta")
      .doc("lastNotification");

    const metaSnap = await metaRef.get();

    if (metaSnap.exists) {
      const lastTime = metaSnap.data().time?.toDate?.();
      const now = new Date();

      if (lastTime && now - lastTime < 5000) {
        console.log("Rate limit hit – skipping notification");
        return;
      }
    }

    await metaRef.set({ time: new Date() });

    // ── 4. Get FCM token ─────────────────────────────────────
    const ownerSnap = await db.collection("users").doc(questionOwnerId).get();

    if (!ownerSnap.exists) {
      console.log(`User ${questionOwnerId} not found.`);
      return;
    }

    const fcmToken = ownerSnap.data().fcmToken;

    // ── 5. Send to owner (DATA-ONLY) ─────────────────────────
    if (fcmToken) {
      const message = {
        token: fcmToken,
        data: {
          title: "New Answer 💬",
          body: `${answerAuthorName} answered your question`,
          question_id: questionId,
          answer_id: answerId,
          deep_link: `app://question/${questionId}`,
        },
        android: {
          priority: "high",
          collapseKey: `question_${questionId}`,
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
        },
      };

      try {
        const res = await getMessaging().send(message);
        console.log("Owner notification sent:", res);
      } catch (error) {
        console.error("Owner send error:", error);

        if (
          error.code === "messaging/registration-token-not-registered" ||
          error.code === "messaging/invalid-registration-token"
        ) {
          await db
            .collection("users")
            .doc(questionOwnerId)
            .update({ fcmToken: null });

          console.log("Stale token cleared.");
        }
      }
    }

    // ── 6. Notify topic subscribers (DATA ONLY) ───────────────
    try {
      const topicMessage = {
        topic: `question_${questionId}`,
        data: {
          title: "New Answer 💬",
          body: `${answerAuthorName} replied to a question you follow`,
          question_id: questionId,
          answer_id: answerId,
          deep_link: `app://question/${questionId}`,
        },
        android: {
          priority: "high",
          collapseKey: `question_${questionId}`,
        },
      };

      await getMessaging().send(topicMessage);
      console.log("Topic notification sent.");
    } catch (e) {
      console.error("Topic send error:", e);
    }
  }
);