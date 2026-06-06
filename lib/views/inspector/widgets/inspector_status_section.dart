import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class InspectorStatusSection extends StatelessWidget {
  final bool isFlagged;
  final bool isApproved;
  final bool isInProgress;
  final bool isRejected;

  const InspectorStatusSection({
    super.key,
    required this.isFlagged,
    required this.isApproved,
    this.isInProgress = false,
    this.isRejected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isRejected) {
      return Row(
        children: [
          SvgPicture.asset(
            "assets/images/flag.svg",
            colorFilter: const ColorFilter.mode(
              AppColors.error,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            "Rejected",
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (isFlagged) {
      return Row(
        children: [
          SvgPicture.asset(
            "assets/images/flag.svg",
            colorFilter: const ColorFilter.mode(
              AppColors.error,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            "Fraud Flagged",
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (isApproved) {
      return const Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success),
          SizedBox(width: 6),
          Text(
            "Approved",
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    if (isInProgress) {
      return const Row(
        children: [
          Icon(Icons.play_circle_outline, color: Colors.blue),
          SizedBox(width: 6),
          Text(
            "In Progress",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
