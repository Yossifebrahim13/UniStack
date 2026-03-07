import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Dotindecator extends StatelessWidget {
  const Dotindecator({super.key, required this.pages, required this.pageIndex});
  final List pages;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (i) => Container(
          margin: const EdgeInsets.all(4),
          height: 10,
          width: pageIndex == i ? 24 : 10,
          decoration: BoxDecoration(
            color: pageIndex == i ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
