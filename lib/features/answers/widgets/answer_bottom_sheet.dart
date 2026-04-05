import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/features/answers/controllers/answer_controller.dart';
import 'package:UniStack/shared/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showAddAnswerBottomSheet(
  BuildContext context,
  String questionId,
  double screenHeight,
) {
  final bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<AnswerController>();

  Get.bottomSheet(
    GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.02,
              vertical: screenHeight * 0.02,
            ),
            decoration: const BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Handle bar
                    Center(
                      child: Container(
                        width: screenHeight * 0.1,
                        height: screenHeight * 0.005,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.shadow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    /// Title
                    Text(
                      "Add Answer",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(screenHeight * 0.004),
                    Text(
                      "Share your answer with the community",
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    Gap(screenHeight * 0.024),

                    /// Answer Body Label
                    Text(
                      "Your Answer",
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(screenHeight * 0.008),

                    CustomField(
                      hintText: "Write your solution or explanation here...",
                      maxLines: 6,
                      controller: bodyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your answer';
                        }
                        if (value.length < 5) {
                          return 'Answer must be at least 5 characters';
                        }
                        return null;
                      },
                    ),

                    Gap(screenHeight * 0.03),

                    /// Post Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  bool success = await controller.addAnswer(
                                    questionId: questionId,
                                    body: bodyController.text.trim(),
                                  );

                                  if (success) {
                                    bodyController.clear();

                                    if (Get.isBottomSheetOpen ?? false) {
                                      Get.back();
                                    }

                                    Get.snackbar(
                                      "Success",
                                      "Answer posted successfully",
                                      backgroundColor: AppColors.success,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(
                                        screenHeight * 0.015,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.016,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenHeight * 0.012,
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.primary
                                .withOpacity(0.6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.isLoading.value
                                    ? "Posting..."
                                    : "Post Answer",
                                style: TextStyle(
                                  fontSize: screenHeight * 0.016,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Gap(screenHeight * 0.01),
                              if (controller.isLoading.value)
                                SizedBox(
                                  width: screenHeight * 0.018,
                                  height: screenHeight * 0.018,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: screenHeight * 0.02,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
