// lib/views/widgets/custom_full_button.dart

import 'package:cook_waiter/App/Themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomFullButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final double? height;
  final double? width;

  const CustomFullButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.white,
                size: 30, // adjust size as needed
              )
            : Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
