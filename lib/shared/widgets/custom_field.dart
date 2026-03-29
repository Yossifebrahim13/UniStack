import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.maxLines,
    this.controller,
    this.validator,
  });
  final String hintText;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.inputFill,
      ),
      validator: widget.validator,
    );
  }
}
