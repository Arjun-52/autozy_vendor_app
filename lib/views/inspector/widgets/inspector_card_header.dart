import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class InspectorCardHeader extends StatelessWidget {
  final bool isFlagged;
  final bool isApproved;
  final String vehicle;
  final String name;

  const InspectorCardHeader({
    super.key,
    required this.isFlagged,
    required this.isApproved,
    required this.vehicle,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: isFlagged || isApproved
                ? AppColors.border
                : AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isFlagged
              ? const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.textSecondary,
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "assets/images/car2.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isFlagged
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 6),
                const Text(
                  "• SUV",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        if (!isFlagged) const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
