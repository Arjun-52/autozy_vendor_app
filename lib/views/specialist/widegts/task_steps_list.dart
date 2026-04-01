import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TaskStepsList extends StatelessWidget {
  final List<String> steps;
  final List<bool> completed;
  final Function(int)? onTap;

  const TaskStepsList({
    super.key,
    required this.steps,
    required this.completed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isDone = index < completed.length && completed[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: () => onTap?.call(index),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: isDone ? AppColors.success : AppColors.textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  step,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
