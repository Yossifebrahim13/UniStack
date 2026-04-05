import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/widgets/category_chip.dart';
import 'package:UniStack/shared/widgets/status_chip.dart';
import 'package:UniStack/shared/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EnhancedQuestionCard extends StatelessWidget {
  final QuestionModel question;

  const EnhancedQuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.icon.withOpacity(0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Subtle accent gradient in the corner for a "premium" feel
            Positioned(
              top: -screenHeight * 0.05,
              right: -screenWidth * 0.05,
              child: CircleAvatar(
                radius: screenHeight * 0.05,
                backgroundColor: AppColors.icon.withOpacity(0.03),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Category and User
                  Row(
                    children: [
                      categoryChip(question.category, screenWidth),
                      const Spacer(),
                      userInfo(screenWidth, question.userName),
                    ],
                  ),
                  Gap(screenHeight * 0.02),

                  // Title: High emphasis
                  Text(
                    question.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.2,
                      height: 1.3,
                    ),
                  ),
                  Gap(screenHeight * 0.01),

                  // Body: Improved readability
                  Text(
                    question.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                  Gap(screenHeight * 0.02),

                  // Footer: Stats and Status
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.icon.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: AppColors.textSecondary.withOpacity(0.6),
                        ),
                        Gap(screenHeight * 0.005),
                        Text(
                          '${question.answersCount} answers',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        statusChip(question.isAnswered, screenWidth),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
