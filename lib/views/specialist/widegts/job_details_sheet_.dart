import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../data/models/specialist_job_model.dart';
import 'detail_row.dart';

class JobDetailsSheet extends StatelessWidget {
  final SpecialistJobModel job;

  const JobDetailsSheet({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DRAG HANDLE
            Align(
              alignment: Alignment.center,
              child: Container(
                width: AppSpacing.xl,
                height: AppSpacing.xs,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
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
                    Text(job.vehicle.vehicleNumber, style: AppStyles.bodyMedium),
                    Text(
                      "${job.user.name} • ${job.vehicle.brand} ${job.vehicle.model}",
                      style: AppStyles.caption,
                    ),
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
                children: [
                  DetailRow(Icons.phone, "Phone: ${job.user.phone}"),
                  const SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.calendar_today, "Scheduled: ${job.scheduledDate}"),
                  const SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.access_time, "Slot: ${job.scheduledSlotStart} - ${job.scheduledSlotEnd}"),
                  const SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.build, "Service: ${job.addonService.name}"),
                  const SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.timer, "Duration: ${job.addonService.estimatedDurationMinutes} mins"),
                  const SizedBox(height: AppSpacing.sm),
                  DetailRow(Icons.description, "Description: ${job.addonService.description}"),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            const Text("Parking Information", style: AppStyles.bodyMedium),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Building: ${job.vehicle.building ?? 'N/A'}", style: AppStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  Text("Flat/Door: ${job.vehicle.flatNo ?? 'N/A'}", style: AppStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  Text("Locality: ${job.vehicle.locality ?? 'N/A'}", style: AppStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  Text("Landmark: ${job.vehicle.landmark ?? 'N/A'}", style: AppStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  Text("Parking Notes: ${job.vehicle.parkingNotes ?? 'N/A'}", style: AppStyles.caption),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            /// STATUS
            Row(
              children: [
                const Text("Status", style: AppStyles.caption),
                const SizedBox(width: AppSpacing.xs),
                Text("• ${job.status}", style: AppStyles.warningButton),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
