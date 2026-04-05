import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/questions/controllers/questions_controller.dart';
import 'package:UniStack/features/questions/widgets/questions_card.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:UniStack/shared/widgets/search_filed.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuestionsView extends StatelessWidget {
  const QuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuestionsController>();
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),
        body: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.scaffold,
          onRefresh: () => controller.getQuestions(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.02,
            ),
            child: ListView(
              children: [
                Text(
                  "All Questions",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Explore the latest academic queries from \n your community",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                Gap(screenWidth * 0.05),
                SearchField(
                  onSearch: (value) => controller.getQuestionsBySearch(value),
                ),
                Gap(screenWidth * 0.05),

                Obx(() {
                  if (controller.isLoading.value &&
                      controller.filteredQuestions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.1),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (controller.filteredQuestions.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Gap(screenWidth * 0.2),
                          Icon(
                            Icons.question_mark,
                            size: screenWidth * 0.15,
                            color: Colors.grey.shade400,
                          ),
                          Gap(screenWidth * 0.04),
                          Text("No unanswered questions found"),
                        ],
                      ),
                    );
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
                        return QuestionCard(
                          question: controller.filteredQuestions[index],
                          onTap: () => Get.offNamed(
                            AppRoutes.answers,
                            arguments: controller.filteredQuestions[index],
                          ),
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
}
