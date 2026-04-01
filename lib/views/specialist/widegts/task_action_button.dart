import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TaskActionButton extends StatelessWidget {
  final bool isStarted;
  final VoidCallback onPressed;

  const TaskActionButton({
    super.key,
    required this.isStarted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.timer_outlined, color: AppColors.textPrimary),
        label: Text(
          isStarted ? "Complete Job" : "Start Job",
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
