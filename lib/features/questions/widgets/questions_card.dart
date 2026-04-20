import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/functions/date_format.dart';
import 'package:UniStack/shared/widgets/category_chip.dart';
import 'package:UniStack/shared/widgets/stat_item.dart';
import 'package:UniStack/shared/widgets/status_chip.dart';
import 'package:UniStack/shared/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question, required this.onTap});
  final QuestionModel question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.01,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.5),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.card, AppColors.card.withOpacity(0.8)],
                  ),
                ),
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Row
                    Row(
                      children: [
                        categoryChip(question.category, screenWidth),
                        const Spacer(),
                        userInfo(screenWidth, question.userName),
                      ],
                    ),

                    Gap(screenWidth * 0.04),

                    /// Question Title
                    Text(
                      question.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                        height: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    Gap(screenWidth * 0.02),

                    /// Question Body
                    Text(
                      question.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        height: 1.5,
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),

                    Gap(screenWidth * 0.05),

                    Divider(
                      color: AppColors.border.withOpacity(0.5),
                      height: 1,
                    ),
                    Gap(screenWidth * 0.02),

                    /// Bottom Row
                    Row(
                      children: [
                        statItem(
                          icon: Icons.chat_bubble_outlined,
                          label: "${question.answersCount} Answers",
                          screenWidth: screenWidth,
                        ),
                        Gap(screenWidth * 0.04),
                        statItem(
                          icon: Icons.access_time_rounded,
                          label: formatDate(question.createdAt),
                          screenWidth: screenWidth,
                        ),
                        const Spacer(),
                        statusChip(question.isAnswered, screenWidth),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
