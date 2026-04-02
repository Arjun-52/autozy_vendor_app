import 'package:autozy_vendor_app/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class JobDetailsBottomSheet extends StatelessWidget {
  final String vehicle;
  final String name;
  final String location;
  final String phone;
  final bool isCNA;
  final int? index;
  final JobModel job;

  const JobDetailsBottomSheet({
    super.key,
    required this.vehicle,
    required this.name,
    required this.location,
    required this.phone,
    this.isCNA = false,
    this.index,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (job.status) {
      case JobStatus.completed:
        statusText = "Completed";
        statusColor = AppColors.success;
        break;
      case JobStatus.cna:
        statusText = "Car Not Available";
        statusColor = AppColors.error;
        break;
      default:
        statusText = "Pending";
        statusColor = AppColors.warning;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),

            /// drag handle
            Container(
              height: AppSpacing.xs,
              width: AppSpacing.xl,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: AppSpacing.all16,
                children: [
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

                  /// vehicle row
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: isCNA ? AppColors.border : AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            10,
                          ), // ✅ acceptable small inline
                          child: SvgPicture.asset(
                            "assets/images/car2.svg",
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              isCNA ? AppColors.error : AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vehicle, style: AppStyles.bodyMedium),
                          Text(name, style: AppStyles.caption),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  /// info card
                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Column(
                      children: [
                        _row(Icons.location_on, location),
                        const SizedBox(height: AppSpacing.sm),
                        _row(Icons.location_pin, "GPS Tracked • Live"),
                        const SizedBox(height: AppSpacing.sm),
                        _row(
                          Icons.call,
                          phone.isEmpty ? "No phone available" : phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  /// status
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Status • "),
                        TextSpan(
                          text: statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: AppSpacing.all16,
              child: Container(
                width: double.infinity,
                padding: AppSpacing.vertical16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/call.svg",
                      height: AppSpacing.lg,
                      width: AppSpacing.lg,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Text("Call Owner", style: AppStyles.buttonText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: AppStyles.body)),
      ],
    );
  }
}
