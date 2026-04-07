import 'package:autozy_vendor_app/core/utils/capture_photo_sheet.dart';
import 'package:autozy_vendor_app/core/utils/job_details_sheet.dart';
import 'package:autozy_vendor_app/core/utils/top_banner.dart';
import 'package:autozy_vendor_app/data/models/inspection_model.dart';
import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

import 'inspector_card_header.dart';
import 'inspector_location_row.dart';
import 'inspector_status_section.dart';
import 'inspector_action_buttons.dart';

class InspectorCard extends StatelessWidget {
  final InspectionModel inspection;
  final int index;

  const InspectorCard({
    super.key,
    required this.inspection,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<InspectorViewModel>();

    final isFlagged = inspection.status == InspectionStatus.flagged;
    final isApproved = inspection.status == InspectionStatus.approved;

    return GestureDetector(
      onTap: () => showJobDetailsSheet(context, inspection),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),

        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),

        decoration: BoxDecoration(
          color: isFlagged ? AppColors.border : AppColors.surface,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isFlagged
                ? AppColors.error.withValues(alpha: 0.3)
                : const Color(0xFFE9E9E9),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF161616).withValues(alpha: 0.12),
              blurRadius: 13,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InspectorCardHeader(
              isFlagged: isFlagged,
              isApproved: isApproved,
              vehicle: inspection.vehicle,
              name: inspection.name,
            ),

            const SizedBox(height: AppSpacing.sm),

            InspectorLocationRow(location: inspection.location),

            const SizedBox(height: AppSpacing.md),

            InspectorStatusSection(
              isFlagged: isFlagged,
              isApproved: isApproved,
            ),

            const SizedBox(height: AppSpacing.md),

            if (!isFlagged && !isApproved)
              InspectorActionButtons(
                photoCount: inspection.photoCount,

                onTakePhoto: () {
                  showCapturePhotoSheet(
                    context: context,
                    onTakePhoto: () => vm.addPhoto(index),
                  );
                },

                onApprove: () {
                  if (inspection.photoCount == 0) {
                    TopBanner(
                      context,
                      "Take at least 1 photo before approving",
                    );
                    return;
                  }

                  vm.approveInspection(index);
                },

                onFlag: () => vm.flagInspection(index),
              ),
          ],
        ),
      ),
    );
  }
}
