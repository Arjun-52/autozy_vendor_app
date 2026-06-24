import 'package:autozy_vendor_app/viewmodels/job_details_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/data/models/inspection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jobDetailsVm = context.read<JobDetailsViewModel>();
      context.read<InspectorViewModel>().fetchInspectionBySubscription(jobDetailsVm.vehicleNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<JobDetailsViewModel>(context);

    return Container(
      padding: AppSpacing.horizontal20Vertical16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// drag handle
          Center(
            child: Container(
              width: AppSpacing.custom40,
              height: AppSpacing.xs,
              margin: AppSpacing.bottom16,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),

          /// header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColors.black),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text("Job Details", style: AppStyles.heading18Bold),
            ],
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// vehicle + name
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: vm.vehicleImage != null && vm.vehicleImage!.isNotEmpty
                      ? Image.network(
                          vm.vehicleImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Padding(
                            padding: AppSpacing.all14,
                            child: SvgPicture.asset(
                              "assets/images/car2.svg",
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                AppColors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: AppSpacing.all14,
                          child: SvgPicture.asset(
                            "assets/images/car2.svg",
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vm.vehicleNumber, style: AppStyles.body16Bold),
                  Text(vm.customerName, style: AppStyles.greyText),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// info card
          Container(
            padding: AppSpacing.all14,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              children: [
                _infoRow(Icons.location_on, vm.location),
                const SizedBox(height: AppSpacing.custom10),
                _infoRow(Icons.gps_fixed, "GPS Tracked • Live"),
                const SizedBox(height: AppSpacing.custom10),
                _infoRow(Icons.call, vm.phone),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// status
          Row(
            children: [
              const Text("Status • "),
              Text(vm.status, style: AppStyles.status),
            ],
          ),

          const SizedBox(height: AppSpacing.custom20),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.custom10),
          const Text("Inspection Details", style: AppStyles.heading18Bold),
          const SizedBox(height: AppSpacing.custom10),

          Consumer<InspectorViewModel>(
            builder: (context, inspectorVm, child) {
              if (inspectorVm.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (inspectorVm.errorMessage != null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        inspectorVm.errorMessage!,
                        style: const TextStyle(color: AppColors.danger),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          inspectorVm.fetchInspectionBySubscription(vm.vehicleNumber);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentYellow,
                        ),
                        child: const Text("Retry", style: TextStyle(color: AppColors.black)),
                      ),
                    ],
                  ),
                );
              }

              final inspection = inspectorVm.currentSubscriptionInspection;
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
                width: double.infinity,
                padding: AppSpacing.all14,
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
                    const SizedBox(height: AppSpacing.custom10),
                    Row(
                      children: [
                        const Text("Location: ", style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(inspection.location),
                      ],
                    ),
                    if (inspection.completedAt != null) ...[
                      const SizedBox(height: AppSpacing.custom10),
                      Row(
                        children: [
                          const Text("Completed At: ", style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(inspection.completedAt!),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.custom10),
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

          const SizedBox(height: AppSpacing.custom20),

          /// button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: vm.callOwner,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                padding: AppSpacing.vertical16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius14),
                ),
              ),
              icon: const Icon(Icons.call, color: AppColors.black),
              label: const Text("Call Owner", style: AppStyles.buttonBold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.grey600),
        const SizedBox(width: AppSpacing.custom10),
        Text(text),
      ],
    );
  }
}
