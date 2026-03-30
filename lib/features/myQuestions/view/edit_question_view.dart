import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/myQuestions/controllers/myQuestion_controller.dart';
import 'package:UniStack/shared/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class EditQuestionView extends StatefulWidget {
  final QuestionModel question;
  const EditQuestionView({super.key, required this.question});

  @override
  State<EditQuestionView> createState() => _EditQuestionViewState();
}

class _EditQuestionViewState extends State<EditQuestionView> {
  final controller = Get.find<MyQuestionsController>();

  late TextEditingController titleController;
  late TextEditingController bodyController;
  late TextEditingController categoryController; // Controller جديد للكاتيجوري

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.question.title);
    bodyController = TextEditingController(text: widget.question.body);
    categoryController = TextEditingController(text: widget.question.category);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: CustomAppBar(screenWidth: screenWidth, showBackButton: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Question",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  wordSpacing: 2,
                  letterSpacing: 2,
                ),
              ),
              Gap(screenWidth * 0.05),
              _buildSectionHeader("Question Title", Icons.title, screenWidth),
              Gap(screenWidth * 0.02),
              _buildTextField(
                controller: titleController,
                hint: "Update your question title...",
              ),
              Gap(screenWidth * 0.05),

              _buildSectionHeader(
                "Category",
                Icons.category_outlined,
                screenWidth,
              ),
              Gap(screenWidth * 0.02),
              // الكاتيجوري بقت TextField دلوقتي
              _buildTextField(
                controller: categoryController,
                hint: "e.g. Flutter, Java, SQL...",
              ),
              Gap(screenWidth * 0.05),

              _buildSectionHeader(
                "Question Body",
                Icons.description,
                screenWidth,
              ),
              Gap(screenWidth * 0.02),
              _buildTextField(
                controller: bodyController,
                hint: "Explain your problem in detail...",
                maxLines: 6,
              ),
              Gap(screenWidth * 0.05),

              // Save Changes Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.editMyQuestion(
                        QuestionModel(
                          id: widget.question.id,
                          title: titleController.text.trim(),
                          body: bodyController.text.trim(),
                          category: categoryController.text.trim(),
                          userId: widget.question.userId,
                          userName: widget.question.userName,
                          createdAt: DateTime.now(),
                        ),
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            controller.isLoading.value
                                ? "Saving..."
                                : "Save Changes",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, double screenWidth) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        Gap(screenWidth * 0.02),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a value";
        }
        if (value.length < 3) {
          return "Please enter at least 3 characters";
        }
        if (value.length > 100) {
          return "Please enter at most 100 characters";
        }

        return null;
      },
    );
  }
}
