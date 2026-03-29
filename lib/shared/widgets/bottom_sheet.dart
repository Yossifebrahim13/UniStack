import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/features/myQuestions/controllers/myQuestion_controller.dart';
import 'package:UniStack/shared/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showAskQuestionBottomSheet(BuildContext context) {
  final controller = Get.find<MyQuestionsController>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Get.bottomSheet(
    GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.shadow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Title
                    const Text(
                      "Ask a New Question",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    const Text(
                      "Share your doubt with the community",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Gap(20),

                    // Question Title
                    const Text(
                      "Question Title",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    CustomField(
                      hintText: "Enter your question title",
                      maxLines: 1,
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your question title';
                        }
                        if (value.length < 7) {
                          return 'Question title must be at least 7 characters';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    // Question Body
                    const Text(
                      "Question Body",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    CustomField(
                      hintText: "Enter your question body",
                      maxLines: 5,
                      controller: bodyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your question body';
                        }
                        if (value.length < 10) {
                          return 'Question body must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    // Category
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    CustomField(
                      hintText: "Enter a category",
                      maxLines: 1,
                      controller: categoryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        if (value.length < 3) {
                          return 'Category must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const Gap(30),

                    // Post Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          isLoading = true;
                          controller.createQuestion(
                            titleController.text,
                            bodyController.text,
                            categoryController.text,
                          );
                          titleController.clear();
                          bodyController.clear();
                          categoryController.clear();
                          Get.back();
                          Get.snackbar(
                            "Success",
                            "Question posted successfully",
                            backgroundColor: AppColors.success,
                            colorText: AppColors.card,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          isLoading = false;
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoading ? "Posting..." : "Post Question",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.card,
                              ),
                            ),
                            const Gap(8),
                            if (isLoading)
                              const CircularProgressIndicator(
                                color: AppColors.card,
                              ),
                            if (!isLoading)
                              const Icon(
                                Icons.send_rounded,
                                color: AppColors.card,
                              ),
                          ],
                        ),
                      ),
                    ),
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
