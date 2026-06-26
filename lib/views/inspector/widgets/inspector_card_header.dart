import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class InspectorCardHeader extends StatelessWidget {
  final bool isFlagged;
  final bool isApproved;
  final String vehicle;
  final String name;
  final String? vehicleName;
  final String? phone;

  const InspectorCardHeader({
    super.key,
    required this.isFlagged,
    required this.isApproved,
    required this.vehicle,
    required this.name,
    this.vehicleName,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final displayUserText = (name.isNotEmpty && name != 'Rohit A.' && name != 'Rohit A')
        ? name
        : (phone != null && phone!.isNotEmpty ? phone! : '');

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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              "assets/images/car2.svg",
              colorFilter: ColorFilter.mode(
                isFlagged || isApproved
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
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
                  if (displayUserText.isNotEmpty) ...[
                    Flexible(
                      child: Text(
                        displayUserText,
                        style: const TextStyle(color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (vehicleName != null && vehicleName!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      const Text("•",
                          style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(width: 6),
                    ],
                  ],
                  if (vehicleName != null && vehicleName!.isNotEmpty)
                    Flexible(
                      child: Text(
                        vehicleName!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        if (!isFlagged) const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
