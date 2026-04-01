import 'package:autozy_vendor_app/core/utils/capture_photo_sheet.dart';
import 'package:autozy_vendor_app/core/utils/job_details_sheet.dart';
import 'package:autozy_vendor_app/core/utils/top_banner.dart';
import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isFlagged ? AppColors.border : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isFlagged
              ? Border.all(color: AppColors.error.withValues(alpha: 0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
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

            const SizedBox(height: 10),

            InspectorLocationRow(location: inspection.location),

            const SizedBox(height: 12),

            InspectorStatusSection(
              isFlagged: isFlagged,
              isApproved: isApproved,
            ),

            const SizedBox(height: 12),

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
                  } else {
                    vm.approveInspection(index);
                  }
                },

                onFlag: () => vm.flagInspection(index),
              ),
          ],
        ),
      ),
    );
  }
}
