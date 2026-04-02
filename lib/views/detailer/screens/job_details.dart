import 'package:autozy_vendor_app/viewmodels/job_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

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
                padding: AppSpacing.all14,
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
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
