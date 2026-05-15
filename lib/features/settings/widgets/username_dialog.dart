import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget buildUserNameDialog({
  required BuildContext context,
  required double screenHeight,
  required Future<void> Function() onSubmit,
  required bool isLoading,
  required TextEditingController controller,
}) {
  return Dialog(
    elevation: 0,
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    child: TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [AppColors.card, AppColors.card.withOpacity(0.95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),

            Gap(screenHeight * 0.02),

            Text(
              "Change Username",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            Gap(screenHeight * 0.01),

            Text(
              "Enter New Username",
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary.withOpacity(0.6),
              ),
            ),

            Gap(screenHeight * 0.02),

            TextFormField(
              controller: controller,
              cursorColor: AppColors.primary,
              style: const TextStyle(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: AppColors.primary,
                ),
                hintText: "Enter Username",
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Username";
                }
                if (value.trim().length < 3) {
                  return "Min 3 Characters";
                }
                if (value.trim().length > 20) {
                  return "Max 20 Characters";
                }
                return null;
              },
            ),

            Gap(screenHeight * 0.03),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: isLoading ? null : onSubmit,

                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    isLoading ? "Loading..." : "Confirm",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.card,
                    ),
                  ),
                ),
              ),
            ),

            Gap(screenHeight * 0.01),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.textPrimary.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
