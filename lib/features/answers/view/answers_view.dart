import 'package:UniStack/features/answers/controllers/answer_controller.dart';
import 'package:UniStack/features/answers/widgets/answer_bottom_sheet.dart';
import 'package:UniStack/features/answers/widgets/answer_card.dart';
import 'package:UniStack/features/answers/widgets/empty_state.dart';
import 'package:UniStack/features/answers/widgets/enhanced_question_card.dart';
import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:UniStack/shared/widgets/glass_loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswersView extends StatelessWidget {
  final QuestionModel question;
  const AnswersView({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnswerController());
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: true),

      floatingActionButton: Obx(() {
        final isOwner = controller.userId.value == question.userId;
        return (isOwner || question.isAnswered)
            ? const SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () => showAddAnswerBottomSheet(
                  context,
                  question.id,
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
                    EnhancedQuestionCard(question: question),
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
    if (controller.isLoading.value && controller.answers.isEmpty) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            3,
            (index) => const Card(child: ListTile(title: Text("Loading..."))),
          ),
        ),
      );
    }

    if (controller.answers.isEmpty) {
      return emptyState(
        screenWidth,
        controller.userId.value == question.userId,
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
          isQuestionOwner: controller.userId.value == question.userId,
          isMyAnswer: answer.userId == controller.userId.value,
          onAccept: () => controller.acceptAnswer(
            questionId: question.id,
            answerId: answer.id,
            questionOwnerId: question.userId,
          ),
          onDismissed: () => controller.deleteAnswer(
            questionId: question.id,
            answerId: answer.id,
            answerOwnerId: answer.userId,
          ),
        );
      },
    );
  }
}
