import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  const AuthBtn({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
  });

  @override
  State<AuthBtn> createState() => _AuthBtnState();
}

class _AuthBtnState extends State<AuthBtn> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = AppSizes(context).screenHeight;
    final screenWidth = AppSizes(context).screenWidth;
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: widget.isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : null,
            ),
            Gap(screenWidth * 0.02),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
