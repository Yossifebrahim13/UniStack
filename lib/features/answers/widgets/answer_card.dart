import 'package:UniStack/core/models/answer_model.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/shared/functions/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnswerCard extends StatelessWidget {
  final AnswerModel answer;
  final bool isQuestionOwner;
  final VoidCallback? onAccept;
  final VoidCallback? onDismissed;
  final bool isMyAnswer;

  const AnswerCard({
    super.key,
    required this.answer,
    this.isQuestionOwner = false,
    this.onAccept,
    this.onDismissed,
    this.isMyAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;
    final bool accepted = answer.isAccepted;
    final Color accentColor = accepted ? AppColors.success : AppColors.primary;

    return Dismissible(
      key: Key(answer.id),
      direction: isMyAnswer
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (direction) => onDismissed?.call(),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: screenWidth * 0.07,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: accepted
                ? AppColors.success.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: accepted
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: accentColor.withOpacity(0.1),
                    child: Text(
                      answer.userName[0].toUpperCase(),
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          answer.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.038,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formatDate(answer.createdAt),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: screenWidth * 0.028,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (accepted) ...[
                    Gap(screenWidth * 0.02),
                    _buildBestAnswerBadge(screenWidth),
                  ],
                ],
              ),
              Gap(screenWidth * 0.04),
              Text(
                answer.body,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  height: 1.5,
                  color: AppColors.textPrimary.withOpacity(0.85),
                ),
              ),
              if (isQuestionOwner && !accepted) ...[
                const Divider(height: 30, color: AppColors.primary),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text("Mark as Best Answer"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestAnswerBadge(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 14),
          Gap(screenWidth * 0.01),
          Text(
            "Best Answer",
            style: TextStyle(
              color: AppColors.success,
              fontSize: screenWidth * 0.028,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
