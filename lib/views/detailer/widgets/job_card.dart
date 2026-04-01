import 'package:autozy_vendor_app/views/detailer/widgets/capture_photo_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ✅ extracted widgets
import 'job_card_header.dart';
import 'job_card_location.dart';
import 'job_card_actions.dart';

class JobCard extends StatelessWidget {
  final String vehicle;
  final String name;
  final String location;
  final bool isCompleted;
  final int? index;
  final bool isCNA;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.vehicle,
    required this.name,
    required this.location,
    this.isCompleted = false,
    this.index,
    this.isCNA = false,
    this.onTap,
  });

  void _openCapturePhotoBottomSheet(BuildContext context) {
    if (index == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CapturePhotoBottomSheet(jobIndex: index!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isCNA
              ? Border.all(color: AppColors.error.withValues(alpha: 0.2))
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER
            JobCardHeader(
              vehicle: vehicle,
              name: name,
              isCompleted: isCompleted,
              isCNA: isCNA,
            ),

            const SizedBox(height: 10),

            /// 🔹 LOCATION
            JobCardLocation(location: location),

            const SizedBox(height: 12),

            /// 🔹 ACTIONS
            JobCardActions(
              isCompleted: isCompleted,
              isCNA: isCNA,
              index: index,
              onClean: () => _openCapturePhotoBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
