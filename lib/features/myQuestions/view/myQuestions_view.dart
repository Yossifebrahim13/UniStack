import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/myQuestions/controllers/myQuestion_controller.dart';
import 'package:UniStack/features/myQuestions/widgets/info_card.dart';
import 'package:UniStack/features/myQuestions/widgets/myQuestion_card.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:UniStack/shared/widgets/search_filed.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyQuestionsView extends StatelessWidget {
  const MyQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final controller = Get.find<MyQuestionsController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),
        body: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.scaffold,
          onRefresh: () => controller.getMyQuestions(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Gap(screenWidth * 0.04),

                Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoCard(
                          title: "Active \nDiscussions",
                          value: controller.myQuestions.length.toString(),
                        ),
                        InfoCard(
                          title: "Correct \nAnswers",
                          value: controller.correctAnswersCount.value
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(screenWidth * 0.08),
                Text("Search", style: _sectionHeaderStyle(screenWidth)),
                Gap(screenWidth * 0.02),
                SearchField(
                  onSearch: (query) => controller.searchQuestions(query),
                ),

                Gap(screenWidth * 0.05),
                Text("My Questions", style: _sectionHeaderStyle(screenWidth)),
                Gap(screenWidth * 0.03),

                Obx(() {
                  if (controller.isLoading.value &&
                      controller.filteredQuestions.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredQuestions.isEmpty) {
                    return _buildEmptyState(screenWidth);
                  }

                  return Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredQuestions.length,
                      separatorBuilder: (context, index) =>
                          Gap(screenWidth * 0.02),
                      itemBuilder: (context, index) {
                        final question = controller.filteredQuestions[index];
                        return MyQuestionCard(
                          question: question,
                          onTap: () => Get.offNamed(
                            AppRoutes.answers,
                            arguments: question,
                          ),
                          onTapEdit: () => Get.toNamed(
                            AppRoutes.editQuestion,
                            arguments: question,
                          ),
                          onTapDelete: () =>
                              controller.deleteMyQuestion(question.id),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _sectionHeaderStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.06,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      letterSpacing: 1.2,
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.2),
      child: Column(
        children: [
          Icon(
            Icons.question_answer_outlined,
            size: screenWidth * 0.15,
            color: Colors.grey.shade400,
          ),
          Gap(screenWidth * 0.04),
          const Text("No questions found in your history"),
        ],
      ),
    );
  }
}
