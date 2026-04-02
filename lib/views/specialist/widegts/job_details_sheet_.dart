import 'package:autozy_vendor_app/viewmodels/specialist_tasks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import 'detail_row.dart';

class JobDetailsSheet extends StatelessWidget {
  final Task task;

  const JobDetailsSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30), // ✅ allowed (modal style)
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: AppSpacing.xl,
              height: AppSpacing.xs,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),

            /// HEADER
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.black),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text("Job Details", style: AppStyles.subHeading),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            /// VEHICLE INFO
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: SvgPicture.asset(
                    "assets/images/car2.svg",
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.vehicle, style: AppStyles.bodyMedium),
                    const Text("Rohit A • SUV", style: AppStyles.caption),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            /// DETAILS CARD
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                children: const [
                  DetailRow(Icons.location_on, "Tower A, Slot 6"),
                  SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.gps_fixed, "GPS Tracked • Live"),
                  SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.calendar_today, "Interior Deep Clean"),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            /// STATUS
            Row(
              children: [
                const Text("Status", style: AppStyles.caption),
                const SizedBox(width: AppSpacing.xs),
                Text("• Pending", style: AppStyles.warningButton),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
