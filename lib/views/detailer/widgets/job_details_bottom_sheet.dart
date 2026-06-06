import 'package:autozy_vendor_app/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/inspector_viewmodel.dart';
import '../../../data/models/inspection_model.dart';

class JobDetailsBottomSheet extends StatefulWidget {
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
  State<JobDetailsBottomSheet> createState() => _JobDetailsBottomSheetState();
}

class _JobDetailsBottomSheetState extends State<JobDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectorViewModel>().fetchInspectionBySubscription(widget.vehicle);
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (widget.job.status) {
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
                          color: widget.isCNA ? AppColors.border : AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/images/car2.svg",
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              widget.isCNA ? AppColors.error : AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.vehicle, style: AppStyles.bodyMedium),
                          Text(widget.name, style: AppStyles.caption),
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
                        _row(Icons.location_on, widget.location),
                        const SizedBox(height: AppSpacing.sm),
                        _row(Icons.location_pin, "GPS Tracked • Live"),
                        const SizedBox(height: AppSpacing.sm),
                        _row(
                          Icons.call,
                          widget.phone.isEmpty ? "No phone available" : widget.phone,
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

                  const SizedBox(height: AppSpacing.lg),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: AppSpacing.md),
                  const Text("Inspection Details", style: AppStyles.subHeading),
                  const SizedBox(height: AppSpacing.md),

                  Consumer<InspectorViewModel>(
                    builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (vm.errorMessage != null) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                vm.errorMessage!,
                                style: const TextStyle(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  vm.fetchInspectionBySubscription(widget.vehicle);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                child: const Text("Retry", style: TextStyle(color: AppColors.black)),
                              ),
                            ],
                          ),
                        );
                      }

                      final inspection = vm.currentSubscriptionInspection;
                      if (inspection == null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: const Center(
                            child: Text(
                              "No Inspection Available",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Status: ", style: TextStyle(fontWeight: FontWeight.w600)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (inspection.status == InspectionStatus.approved ||
                                           inspection.status == InspectionStatus.completed)
                                        ? Colors.green.shade50
                                        : inspection.status == InspectionStatus.inProgress
                                            ? Colors.blue.shade50
                                            : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    inspection.status.name.toUpperCase(),
                                    style: TextStyle(
                                      color: (inspection.status == InspectionStatus.approved ||
                                             inspection.status == InspectionStatus.completed)
                                          ? Colors.green
                                          : inspection.status == InspectionStatus.inProgress
                                              ? Colors.blue
                                              : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                const Text("Location: ", style: TextStyle(fontWeight: FontWeight.w600)),
                                Text(inspection.location),
                              ],
                            ),
                            if (inspection.completedAt != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  const Text("Completed At: ", style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text(inspection.completedAt!),
                                ],
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                const Text("Photos Count: ", style: TextStyle(fontWeight: FontWeight.w600)),
                                Text("${inspection.photoCount}"),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: AppSpacing.all16,
              child: GestureDetector(
                onTap: () {
                  _makePhoneCall("9876543210");
                },
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
