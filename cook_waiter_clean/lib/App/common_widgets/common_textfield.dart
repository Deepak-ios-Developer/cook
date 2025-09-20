import 'package:flutter/material.dart';
import 'package:cook_waiter/App/Themes/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const CommonTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.textFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // smooth corners
          borderSide: BorderSide.none, // remove border line
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
