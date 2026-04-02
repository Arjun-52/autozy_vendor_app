import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'status_card.dart';

class DashboardStatusRow extends StatelessWidget {
  const DashboardStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/Car.svg",
              height: AppSpacing.iconMd,
              width: AppSpacing.iconMd,
            ),
            title: "3/40",
            subtitle: "Completed",
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/Car.svg",
              height: AppSpacing.iconMd,
              width: AppSpacing.iconMd,
            ),
            title: "37",
            subtitle: "Remaining",
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/disclaimer.svg",
              height: AppSpacing.iconMd,
              width: AppSpacing.iconMd,
            ),
            title: "0",
            subtitle: "CNA",
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/wifi_off.svg",
              height: AppSpacing.iconMd,
              width: AppSpacing.iconMd,
            ),
            title: "",
            subtitle: "Offline Ready",
          ),
        ),
      ],
    );
  }
}
