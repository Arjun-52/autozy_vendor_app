import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class TaskCardHeader extends StatelessWidget {
  final String vehicle;
  final String title;
  final bool showTimer;
  final VoidCallback onTap;

  const TaskCardHeader({
    super.key,
    required this.vehicle,
    required this.title,
    required this.showTimer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardHighlight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            "assets/images/car2.svg",
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const Spacer(),

        if (showTimer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.warning),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: AppColors.warning),
                SizedBox(width: 4),
                Text("00:54", style: TextStyle(color: AppColors.warning)),
              ],
            ),
          ),

        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: onTap,
        ),
      ],
    );
  }
}
