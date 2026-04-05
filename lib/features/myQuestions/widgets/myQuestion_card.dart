import 'package:UniStack/core/models/question_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/functions/date_format.dart';
import 'package:UniStack/shared/widgets/category_chip.dart';
import 'package:UniStack/shared/widgets/stat_item.dart';
import 'package:UniStack/shared/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyQuestionCard extends StatelessWidget {
  const MyQuestionCard({
    super.key,
    required this.question,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.onTap,
  });
  final QuestionModel question;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          border: Border.all(color: AppColors.border.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          child: Stack(
            children: [
              Positioned(
                right: -screenWidth * 0.08,
                top: -screenWidth * 0.08,
                child: CircleAvatar(
                  radius: screenWidth * 0.15,
                  backgroundColor: AppColors.primary.withOpacity(0.04),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.045),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Row (Category + Actions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryChip(question.category, screenWidth),
                        Row(
                          children: [
                            _buildActionButton(
                              icon: Icons.edit_outlined,
                              color: AppColors.primary,
                              onTap: onTapEdit, // Edit Logic
                            ),
                            Gap(screenWidth * 0.03),
                            _buildActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: AppColors.error,
                              onTap: onTapDelete, // Delete Logic
                            ),
                          ],
                        ),
                      ],
                    ),

                    Gap(screenWidth * 0.03),

                    /// Question Title
                    Text(
                      question.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screenWidth * 0.046,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),

                    Gap(screenWidth * 0.015),

                    /// Question Body
                    Text(
                      question.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screenWidth * 0.034,
                        height: 1.5,
                        color: AppColors.textSecondary.withOpacity(0.85),
                      ),
                    ),

                    Gap(screenWidth * 0.02),
                    Divider(
                      color: AppColors.border.withOpacity(0.5),
                      height: 1,
                    ),
                    Gap(screenWidth * 0.02),

                    /// Bottom Row (Stats + Status)
                    Row(
                      children: [
                        statItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: "${question.answersCount}",
                          screenWidth: screenWidth,
                        ),
                        Gap(screenWidth * 0.02),
                        statItem(
                          icon: Icons.calendar_today_rounded,
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

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
