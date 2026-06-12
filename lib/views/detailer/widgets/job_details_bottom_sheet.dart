import 'dart:io';
import 'package:autozy_vendor_app/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/inspector_viewmodel.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../data/models/inspection_model.dart';
import '../../../core/di/dependency_injection.dart';
import 'capture_photo_bottom_sheet.dart';

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
  bool _isUploadingBeforePhoto = false;
  String? _errorMessage;

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

  Future<void> _pickAndUploadPhoto(BuildContext context, DashboardViewModel dashboardVm) async {
    if (widget.index == null) return;
    
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    } catch (e) {
      setState(() {
        _errorMessage = "Camera permission denied";
      });
      return;
    }

    if (pickedFile == null) return;

    setState(() {
      _isUploadingBeforePhoto = true;
      _errorMessage = null;
    });

    try {
      final file = File(pickedFile.path);
      final response = await di.inspectorRepository.uploadImage(file);
      if (response.success) {
        final imageUrl = response.data.url;
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        
        dashboardVm.updateBeforePhoto(widget.index!, imageUrl, timestamp);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Before-cleaning photo uploaded successfully!")),
          );
        }
      } else {
        setState(() {
          _errorMessage = "Upload failed: API error";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Upload failed: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingBeforePhoto = false;
        });
      }
    }
  }

  Widget _buildBeforePhotoSection(BuildContext context, JobModel job, DashboardViewModel dashboardVm) {
    final hasBeforePhoto = job.beforeImage != null && job.beforeImage!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Divider(color: AppColors.border),
        const SizedBox(height: AppSpacing.md),
        const Text("Before-Cleaning Photo", style: AppStyles.subHeading),
        const SizedBox(height: AppSpacing.md),
        if (hasBeforePhoto) ...[
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              image: DecorationImage(
                image: NetworkImage(job.beforeImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  SizedBox(width: 6),
                  Text(
                    "Before Photo Uploaded ✓",
                    style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (job.status == JobStatus.pending)
                TextButton.icon(
                  onPressed: () => _pickAndUploadPhoto(context, dashboardVm),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Retake"),
                ),
            ],
          ),
          if (job.capturedAt != null)
            Text(
              "Captured at: ${job.capturedAt}",
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
        ] else ...[
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: const Center(
              child: Text(
                "No before-cleaning photo uploaded yet",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_isUploadingBeforePhoto)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickAndUploadPhoto(context, dashboardVm),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.camera_alt, color: AppColors.black),
                label: const Text("Upload Before Photo", style: AppStyles.buttonSmall),
              ),
            ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 6),
          Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVm = context.watch<DashboardViewModel>();
    final job = widget.index != null ? dashboardVm.getJob(widget.index!) ?? widget.job : widget.job;

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
      case JobStatus.cleaning:
        statusText = "Cleaning in Progress";
        statusColor = AppColors.primary;
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
                          color: job.isCNA ? AppColors.border : AppColors.primary,
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
                              job.isCNA ? AppColors.error : AppColors.black,
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

                  _buildBeforePhotoSection(context, job, dashboardVm),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (job.status == JobStatus.pending) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (job.beforeImage != null && job.beforeImage!.isNotEmpty)
                            ? () async {
                                final success = await dashboardVm.startJobCleaning(widget.index!);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Cleaning started successfully!")),
                                  );
                                }
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please upload a before-cleaning photo before starting this job."),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (job.beforeImage != null && job.beforeImage!.isNotEmpty)
                              ? AppColors.primary
                              : AppColors.border,
                          padding: AppSpacing.vertical16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        child: Text(
                          "Start Cleaning",
                          style: TextStyle(
                            color: (job.beforeImage != null && job.beforeImage!.isNotEmpty)
                                ? AppColors.black
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ] else if (job.status == JobStatus.cleaning) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CapturePhotoBottomSheet(jobIndex: widget.index!),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: AppSpacing.vertical16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        child: const Text(
                          "Complete Job",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  
                  GestureDetector(
                    onTap: () {
                      _makePhoneCall(widget.phone.isEmpty ? "9876543210" : widget.phone);
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
                ],
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
