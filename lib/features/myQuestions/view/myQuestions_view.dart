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
    final screenHeight = AppSizes(context).screenHeight;
    final controller = Get.find<MyQuestionsController>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.scaffold,
        onRefresh: () => controller.getMyQuestions(),
        child: Scaffold(
          backgroundColor: AppColors.scaffold,
          appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenWidth * 0.02,
            ),
            child: ListView(
              children: [
                Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: SizedBox(
                      height: screenHeight * 0.2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Gap(screenWidth * 0.1),
                          InfoCard(
                            title: "Active \nDiscussions",
                            value: controller.myQuestions.length.toString(),
                          ),

                          Gap(screenWidth * 0.05),
                          InfoCard(
                            title: "Correct \nAnswers",
                            value: controller.myQuestions
                                .where((question) => question.isAnswered)
                                .length
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Gap(screenWidth * 0.05),

                Text(
                  "Search",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                ),

                Gap(screenWidth * 0.02),

                SearchField(
                  onSearch: (query) {
                    controller.searchQuestions(query);
                  },
                ),
                Gap(screenWidth * 0.05),

                Text(
                  "My Questions",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                ),

                Gap(screenWidth * 0.05),

                Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredQuestions.length,
                      itemBuilder: (context, index) {
                        final question = controller.filteredQuestions[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenWidth * 0.02,
                          ),
                          child: MyQuestionCard(
                            question: question,
                            onTapEdit: () => Get.toNamed(
                              AppRoutes.editQuestion,
                              arguments: question,
                            ),
                            onTapDelete: () =>
                                controller.deleteMyQuestion(question.id),
                          ),
                        );
                      },
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
