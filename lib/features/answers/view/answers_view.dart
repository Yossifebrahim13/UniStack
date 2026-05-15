import 'package:UniStack/features/answers/controllers/answer_controller.dart';
import 'package:UniStack/features/answers/widgets/answer_bottom_sheet.dart';
import 'package:UniStack/features/answers/widgets/answer_card.dart';
import 'package:UniStack/features/answers/widgets/empty_state.dart';
import 'package:UniStack/features/answers/widgets/enhanced_question_card.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:UniStack/shared/widgets/glass_loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswersView extends StatelessWidget {
  /// Accepts either a [QuestionModel] (normal navigation from question list)
  /// or a [String] questionId (navigation from a local notification tap).
  /// The controller resolves the full model in both cases.
  final dynamic question;

  const AnswersView({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    // The controller is provided by AnswerBinding on the /answers route.
    final controller = Get.find<AnswerController>();
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),

      floatingActionButton: Obx(() {
        final q = controller.currentQuestion.value;
        if (q == null) return const SizedBox.shrink();
        final isOwner = controller.userId.value == q.userId;
        return (isOwner || q.isAnswered)
            ? const SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () => showAddAnswerBottomSheet(
                  context,
                  q.id,
                  screenHeight,
                ),
                child: Icon(Icons.add, color: AppColors.inputFill),
              );
      }),

      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question card — only rendered once the model is loaded.
                    if (controller.currentQuestion.value != null)
                      EnhancedQuestionCard(
                        question: controller.currentQuestion.value!,
                      ),
                    Gap(screenWidth * 0.05),
                    Text(
                      'Answers',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gap(screenWidth * 0.05),
                    _buildAnswersList(controller, screenWidth),
                  ],
                ),
              ),
            ),
            if (controller.isLoading.value)
              const GlassLoader(message: 'Loading...'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswersList(AnswerController controller, double screenWidth) {
    final q = controller.currentQuestion.value;

    if (controller.isLoading.value && controller.answers.isEmpty) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            3,
            (index) => const Card(child: ListTile(title: Text('Loading...'))),
          ),
        ),
      );
    }

    if (controller.answers.isEmpty) {
      return emptyState(
        screenWidth,
        q != null && controller.userId.value == q.userId,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.answers.length,
      itemBuilder: (context, index) {
        final answer = controller.answers[index];
        return AnswerCard(
          answer: answer,
          isQuestionOwner: q != null && controller.userId.value == q.userId,
          isMyAnswer: answer.userId == controller.userId.value,
          onAccept: () => controller.acceptAnswer(
            questionId: q?.id ?? '',
            answerId: answer.id,
            questionOwnerId: q?.userId ?? '',
          ),
          onDismissed: () => controller.deleteAnswer(
            questionId: q?.id ?? '',
            answerId: answer.id,
            answerOwnerId: answer.userId,
          ),
        );
      },
    );
  }
}
