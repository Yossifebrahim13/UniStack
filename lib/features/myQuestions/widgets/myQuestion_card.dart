import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyQuestionCard extends StatelessWidget {
  const MyQuestionCard({super.key, required this.question});
  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;

    return Card(
      color: AppColors.card,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                /// Category
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.category,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: AppColors.card,
                    ),
                  ),
                ),

                Spacer(),

                /// Actions (Edit, Delete)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit, color: AppColors.primary),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete, color: AppColors.error),
                    ),
                  ],
                ),
              ],
            ),

            Gap(screenWidth * 0.02),

            /// Question Title
            Text(
              question.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            Gap(screenWidth * 0.015),

            /// Question Body
            Text(
              question.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: AppColors.textSecondary,
              ),
            ),

            Gap(screenWidth * 0.025),

            ///  Bottom Row
            Row(
              children: [
                /// Answers Count
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      Gap(4),
                      Text(
                        "${question.answersCount}",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                Gap(screenWidth * 0.04),

                /// Creation Date
                Icon(Icons.calendar_today, size: 18),
                Gap(4),
                Text(
                  _formatDate(question.createdAt),
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                Spacer(),

                /// Question Status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: question.isAnswered
                        ? AppColors.success.withOpacity(0.7)
                        : AppColors.error.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.isAnswered ? "Answered" : "Pending",
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                      color: AppColors.card,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///  Format Date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
