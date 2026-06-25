import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
import '../screens/proof_verification_screen.dart';

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

    final isFlagged = inspection.status == InspectionStatus.flagged ||
        inspection.status == InspectionStatus.rejected;
    final isApproved = inspection.status == InspectionStatus.approved ||
        inspection.status == InspectionStatus.completed ||
        inspection.status == InspectionStatus.verified;
    final isInProgress = inspection.status == InspectionStatus.inProgress;

    // Use localPhotos map/list from model
    final List<String> imageUrls = inspection.localPhotos.map((p) => p.url).toList();

    return GestureDetector(
      onTap: () {
        if (inspection.status == InspectionStatus.pendingVerification) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProofVerificationScreen(inspection: inspection),
            ),
          );
        } else {
          showJobDetailsSheet(context, inspection);
        }
      },

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
              vehicleName: inspection.vehicleName,
            ),

            const SizedBox(height: AppSpacing.sm),

            InspectorLocationRow(location: inspection.location),

            const SizedBox(height: AppSpacing.md),

            InspectorStatusSection(
              isFlagged: isFlagged && inspection.status != InspectionStatus.rejected,
              isApproved: isApproved,
              isInProgress: isInProgress,
              isRejected: inspection.status == InspectionStatus.rejected,
              isPendingVerification: inspection.status == InspectionStatus.pendingVerification,
              isVerified: inspection.status == InspectionStatus.verified,
            ),

            const SizedBox(height: AppSpacing.md),

            if (inspection.status == InspectionStatus.pending)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.startInspection(inspection.id);
                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Inspection started successfully')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to start inspection')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: vm.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Start Inspection",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )
            else if (inspection.status == InspectionStatus.pendingVerification)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProofVerificationScreen(inspection: inspection),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Verify Proof",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (isInProgress)
              InspectorActionButtons(
                photoCount: inspection.localPhotos.length,
                imageUrls: imageUrls,
                isUploading: vm.isUploadingImage && vm.uploadingInspectionId == inspection.id,

                onTakePhoto: () {
                  showCapturePhotoSheet(
                    context: context,
                    onTakePhoto: () => vm.uploadImage(inspection.id, source: ImageSource.camera),
                    onPickGallery: () => vm.uploadImage(inspection.id, source: ImageSource.gallery),
                  );
                },

                onApprove: () async {
                  if (inspection.localPhotos.isEmpty) {
                    TopBanner(
                      context,
                      "Take at least 1 photo before approving",
                    );
                    return;
                  }

                  final photosPayload = inspection.localPhotos.map((photo) => {
                        "url": photo.url,
                        "type": photo.type,
                        "timestamp": photo.timestamp,
                      }).toList();

                  final success = await vm.completeInspection(inspection.id, photosPayload);
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inspection completed successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to complete inspection')),
                    );
                  }
                },

                onFlag: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) {
                      final reasonController = TextEditingController(
                        text: "Vehicle was locked and inspection could not be performed",
                      );
                      return AlertDialog(
                        title: const Text("Fail Inspection"),
                        content: TextField(
                          controller: reasonController,
                          decoration: const InputDecoration(
                            labelText: "Reason",
                            hintText: "Enter the reason for failure",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(dialogCtx);
                              final photosPayload = inspection.localPhotos.map((photo) => photo.url).toList();
                              final success = await vm.failInspection(
                                inspection.id,
                                reasonController.text.trim(),
                                photosPayload,
                              );
                              if (!context.mounted) return;
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Inspection failed successfully')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to flag inspection')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: AppColors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
