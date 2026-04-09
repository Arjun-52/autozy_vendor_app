import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
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
  bool isOnline = false;

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
      backgroundColor: Colors.white,

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
          GestureDetector(
            onTap: () {
              setState(() {
                isOnline = !isOnline;
              });

              handleOnlineToggle(context, isOnline);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: AppSpacing.right16,
              padding: AppSpacing.horizontal12Vertical6,
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.onlineBg.withOpacity(0.5)
                    : Colors.red.withOpacity(0.1),
                border: Border.all(
                  color: isOnline ? AppColors.success : Colors.red,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Text(
                isOnline ? "● Online" : "● Offline",
                style: TextStyle(
                  color: isOnline ? AppColors.success : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
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
