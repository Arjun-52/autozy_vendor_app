import 'package:autozy_vendor_app/core/utils/snackbar_helper.dart';
import 'package:autozy_vendor_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../viewmodels/inspector_viewmodel.dart';
import '../../../core/di/dependency_injection.dart';

class CapturePhotoBottomSheet extends StatefulWidget {
  final int jobIndex;

  const CapturePhotoBottomSheet({super.key, required this.jobIndex});

  @override
  State<CapturePhotoBottomSheet> createState() =>
      _CapturePhotoBottomSheetState();
}

class _CapturePhotoBottomSheetState extends State<CapturePhotoBottomSheet> {
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  bool _isUploading = false;
  bool _isUploadSuccess = false;
  String? _errorMessage;
  final TextEditingController _completionRemarkController = TextEditingController();

  @override
  void dispose() {
    _completionRemarkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (photo != null) {
        setState(() {
          imageFile = File(photo.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Permission denied or capture failed.";
      });
    }
  }

  void _showFullScreenPreview(BuildContext context) {
    if (imageFile == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.file(imageFile!, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadAfterPhoto(DashboardViewModel dashboardVm) async {
    if (imageFile == null) return;
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final response = await di.inspectorRepository.uploadImage(imageFile!);
      if (response.success) {
        final imageUrl = response.data.url;
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        
        dashboardVm.updateAfterPhoto(widget.jobIndex, imageUrl, timestamp);
        
        setState(() {
          _isUploadSuccess = true;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("After photo uploaded successfully.")),
          );
        }
      } else {
        setState(() {
          _errorMessage = "Upload failed: API error";
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Upload failed: $e";
        _isUploading = false;
      });
    }
  }

  void _handleJobCompletion() {
    if (!mounted) return;

    final remarkText = _completionRemarkController.text.trim();
    final dashboardVm = context.read<DashboardViewModel>();
    final vehicle = dashboardVm.getJob(widget.jobIndex)?.vehicle ?? '';

    if (remarkText.isNotEmpty) {
      dashboardVm.addJobRemark(widget.jobIndex, "Job Completed", remarkText);
      context.read<InspectorViewModel>().addRemarkFromDetailer(vehicle, "Job Completed", remarkText);
    }

    dashboardVm.markJobCompleted(widget.jobIndex);

    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (NavigationService.context != null &&
          NavigationService.context!.mounted) {
        SnackbarHelper.showTopNotification(NavigationService.context!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVm = context.watch<DashboardViewModel>();

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// drag handle
          Container(
            height: AppSpacing.xs,
            width: AppSpacing.custom40,
            margin: AppSpacing.bottom12,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),

          /// title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColors.black),
              ),
              const SizedBox(width: AppSpacing.custom10),
              const Text("Capture After-Cleaning Photo", style: AppStyles.title16Medium),
            ],
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// preview box
          GestureDetector(
            onTap: imageFile != null ? () => _showFullScreenPreview(context) : null,
            child: Container(
              height: AppSpacing.custom180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radius14),
                border: Border.all(color: AppColors.grey),
              ),
              child: imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/camera.svg",
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.custom8),
                        const Text(
                          "Tap buttons below to capture / pick",
                          style: AppStyles.smallDark,
                        ),
                      ],
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radius14),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSpacing.radius14),
                            color: Colors.black26,
                          ),
                          child: const Center(
                            child: Icon(Icons.zoom_in, color: Colors.white, size: 36),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.custom20),

          TextField(
            controller: _completionRemarkController,
            decoration: InputDecoration(
              labelText: "Completion Remarks (Optional)",
              hintText: "e.g. Customer requested extra cleaning...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: AppSpacing.custom20),

          if (_errorMessage != null) ...[
            Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            const SizedBox(height: AppSpacing.custom10),
          ],

          if (_isUploadSuccess) ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
                SizedBox(width: 6),
                Text(
                  "After Photo Uploaded Successful ✓",
                  style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          /// buttons
          if (_isUploading)
            const Center(child: CircularProgressIndicator())
          else if (imageFile == null)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(ImageSource.camera),
                    borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    child: Container(
                      padding: AppSpacing.vertical14,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.radius14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/camera.svg",
                            height: AppSpacing.xl,
                            width: AppSpacing.xl,
                            colorFilter: const ColorFilter.mode(
                              AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.custom8),
                          const Text(
                            "Use Camera",
                            style: AppStyles.button16Medium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.custom10),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(ImageSource.gallery),
                    borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    child: Container(
                      padding: AppSpacing.vertical14,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(AppSpacing.radius14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library, color: AppColors.black),
                          const SizedBox(width: AppSpacing.custom8),
                          const Text(
                            "Use Gallery",
                            style: AppStyles.button16Medium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        imageFile = null;
                        _isUploadSuccess = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    child: Container(
                      padding: AppSpacing.vertical14,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(AppSpacing.radius14),
                      ),
                      child: const Center(
                        child: Text("Retake", style: AppStyles.smallDark),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.custom10),
                Expanded(
                  child: InkWell(
                    onTap: _isUploadSuccess
                        ? _handleJobCompletion
                        : () => _uploadAfterPhoto(dashboardVm),
                    borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    child: Container(
                      padding: AppSpacing.vertical14,
                      decoration: _isUploadSuccess
                          ? BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(AppSpacing.radius14),
                            )
                          : BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSpacing.radius14),
                            ),
                      child: Center(
                        child: Text(
                          _isUploadSuccess ? "Complete Job" : "Upload Photo",
                          style: TextStyle(
                            color: _isUploadSuccess ? Colors.white : AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
