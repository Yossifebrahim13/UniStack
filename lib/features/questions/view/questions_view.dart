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
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.scaffold,
        onRefresh: () => controller.getQuestions(),
        child: Scaffold(
          backgroundColor: AppColors.scaffold,

          appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),

          body: Padding(
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
                  "Explore the latest acadmic quries from \n your community",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                Gap(screenWidth * 0.05),
                SearchField(
                  onSearch: (value) {
                    controller.getQuestionsBySearch(value);
                  },
                ),
                Gap(screenWidth * 0.05),
                Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          QuestionCard(
                            question: controller.filteredQuestions[index],
                          ),
                      separatorBuilder: (BuildContext context, int index) =>
                          Gap(screenWidth * 0.02),
                      itemCount: controller.filteredQuestions.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
