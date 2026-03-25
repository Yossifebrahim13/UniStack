import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/myQuestions/widgets/info_card.dart';
import 'package:UniStack/features/myQuestions/widgets/myQuestion_card.dart';
import 'package:UniStack/shared/widgets/search_filed.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyQuestionsView extends StatelessWidget {
  const MyQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenWidth * 0.02,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "lib/core/assets/img/applogo.jpeg",
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(screenWidth * 0.02),
                Text(
                  "UniStack",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenWidth * 0.02,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Gap(screenWidth * 0.1),
                    InfoCard(title: "Active \nDiscussions", value: "5"),
                    Gap(screenWidth * 0.05),
                    InfoCard(title: "Correct \nAnswers", value: "10"),
                  ],
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

              SearchField(onSearch: (query) {}),
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

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: MyQuestionCard(
                      question: QuestionModel(
                        id: "1",
                        title: "What is the capital of Egypt?",
                        body:
                            "the capital of Egypt is Cairo and it is the largest city in the Arab world and the Middle East",
                        category: "Knowledge",
                        answersCount: 5,
                        createdAt: DateTime.now(),
                        isAnswered: true,
                        userId: '',
                        userName: '',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
