import 'package:UniStack/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPasswordHidden = true,
    this.isPass = false,
    this.controller,
    this.validator,
  });

  final String hintText;
  final IconData icon;
  final bool isPass;
  final bool isPasswordHidden;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool isHidden;

  @override
  void initState() {
    super.initState();
    isHidden = widget.isPasswordHidden;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPass ? isHidden : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: Icon(widget.icon, color: AppColors.icon),

        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  isHidden ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.icon,
                ),
                onPressed: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
              )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}