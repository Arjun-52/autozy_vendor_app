import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/views/inspector/widgets/inspector_card.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class InspectorDashboard extends StatefulWidget {
  const InspectorDashboard({super.key});

  @override
  State<InspectorDashboard> createState() => _InspectorDashboardState();
}

class _InspectorDashboardState extends State<InspectorDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectorViewModel>().loadInspections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.go('/role');
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Inspector Mode", style: AppStyles.subHeading),
            Text("Inspection Queue", style: AppStyles.caption),
          ],
        ),
        actions: [
          Container(
            margin: AppSpacing.right16,
            padding: AppSpacing.horizontal12Vertical6,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              border: Border.all(
                color: AppColors.successDark.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const Text(
              "● Online",
              style: TextStyle(
                color: Color(0xff008847),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.all16,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    icon: SvgPicture.asset(
                      "assets/images/Car.svg",
                      height: AppSpacing.iconMd,
                      width: AppSpacing.iconMd,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: vm.approvedCount.toString(),
                    subtitle: "Approved",
                    iconColor: AppColors.black,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatusCard(
                    icon: SvgPicture.asset(
                      "assets/images/Car.svg",
                      height: AppSpacing.iconMd,
                      width: AppSpacing.iconMd,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: vm.pendingCount.toString(),
                    subtitle: "Pending",
                    iconColor: AppColors.black,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatusCard(
                    icon: const Icon(Icons.warning),
                    title: vm.flaggedCount.toString(),
                    subtitle: "Flagged",
                    iconColor: AppColors.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Inspection Queue", style: AppStyles.sectionTitle),
            ),

            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView(
                children: [
                  ...vm.inspections.asMap().entries.map(
                    (entry) => InspectorCard(
                      inspection: entry.value,
                      index: entry.key,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
