import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import 'status_card.dart';

class DashboardStatusRow extends StatelessWidget {
  const DashboardStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final stats = vm.stats;

    final completed = stats['completed'] ?? 0;
    final total = stats['total'] ?? 0;
    final remaining = stats['remaining'] ?? 0;
    final cna = stats['cna'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/Car.svg",
              height: AppSpacing.iconMd,
              width: AppSpacing.iconMd,
            ),
            title: "$completed/$total",
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
            title: "$remaining",
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
            title: "$cna",
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
            subtitle: "Offline\nReady",
          ),
        ),
      ],
    );
  }
}
