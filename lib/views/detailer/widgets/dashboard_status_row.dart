import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/app_colors.dart';
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
              height: 24,
              width: 24,
            ),
            title: "3/40",
            subtitle: "Completed",
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/Car.svg",
              height: 24,
              width: 24,
            ),
            title: "37",
            subtitle: "Remaining",
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/disclaimer.svg",
              height: 24,
              width: 24,
            ),
            title: "0",
            subtitle: "CNA",
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: StatusCard(
            icon: SvgPicture.asset(
              "assets/images/wifi_off.svg",
              height: 24,
              width: 24,
            ),
            title: "",
            subtitle: "Offline Ready",
          ),
        ),
      ],
    );
  }
}
