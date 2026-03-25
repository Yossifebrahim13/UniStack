import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onSearch;
  const SearchField({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: TextField(
        onChanged: onSearch,
        style: TextStyle(color: AppColors.textPrimary),
        cursorColor: AppColors.textPrimary,
        decoration: InputDecoration(
          focusColor: AppColors.textPrimary,
          hintText: "Search by title , body or category",
          hintStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: AppColors.textSecondary.withOpacity(0.6),
          filled: true,
          fillColor: AppColors.scaffold,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.textSecondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.textSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
