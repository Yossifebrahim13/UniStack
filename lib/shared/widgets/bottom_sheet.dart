import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/shared/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showAskQuestionBottomSheet() {
  Get.bottomSheet(
    GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  CustomField(
                    hintText: "e.g. How to solve Maxwell's equations?",
                    maxLines: 1,
                  ),
                  const Gap(16),

                  // Question Body
                  const Text(
                    "Question Body",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  CustomField(
                    hintText: "Provide more details about your question...",
                    maxLines: 5,
                  ),
                  const Gap(16),

                  // Category
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  CustomField(hintText: "Enter a category", maxLines: 1),
                  const Gap(30),

                  // Post Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Post Question",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.card,
                            ),
                          ),
                          const Gap(8),
                          const Icon(Icons.send_rounded, color: AppColors.card),
                        ],
                      ),
                    ),
                  ),
                ],
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
