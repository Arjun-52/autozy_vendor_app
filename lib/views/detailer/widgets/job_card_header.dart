import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class JobCardHeader extends StatelessWidget {
  final String vehicle;
  final String name;
  final bool isCompleted;
  final bool isCNA;

  const JobCardHeader({
    super.key,
    required this.vehicle,
    required this.name,
    required this.isCompleted,
    required this.isCNA,
  });

  @override
  Widget build(BuildContext context) {
    final isMuted = isCNA || isCompleted;

    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: isMuted ? const Color(0xffD1D1D1CC) : AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              "assets/images/car2.svg",
              colorFilter: ColorFilter.mode(
                isCNA ? Colors.red : AppColors.textPrimary,
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
                color: isMuted
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const Spacer(),

        Row(
          children: [
            if (isCompleted)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),

            if (isCompleted) const SizedBox(width: 6),

            isCNA
                ? const Icon(Icons.warning_amber_rounded, color: Colors.red)
                : const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ],
    );
  }
}
