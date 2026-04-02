import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class ContinueButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ContinueButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: AppSpacing.vertical16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.white, // ✅ fixed (visible now)
              )
            : const Text("Continue", style: AppStyles.buttonLarge),
      ),
    );
  }
}
