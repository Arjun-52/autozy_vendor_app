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

  Future<void> takePhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  void _handleJobCompletion() {
    if (!mounted) return;

    context.read<DashboardViewModel>().markJobCompleted(widget.jobIndex);

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
              const Text("Capture Photo", style: AppStyles.title16Medium),
            ],
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// preview box
          Container(
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
                        "Camera Preview Area",
                        style: AppStyles.smallDark,
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
          ),

          const SizedBox(height: AppSpacing.custom20),

          /// buttons
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    takePhoto().then((_) {
                      if (imageFile != null) {
                        _handleJobCompletion();
                      }
                    });
                  },
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
                          "Take Photo",
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
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(AppSpacing.radius14),
                  child: Container(
                    padding: AppSpacing.vertical14,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.error),
                      borderRadius: BorderRadius.circular(AppSpacing.radius14),
                    ),
                    child: const Center(
                      child: Text("Cancel", style: AppStyles.dangerButton),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
