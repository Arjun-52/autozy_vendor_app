import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/top_banner.dart';

class InspectorActionButtons extends StatelessWidget {
  final int photoCount;
  final VoidCallback onApprove;
  final VoidCallback onFlag;
  final VoidCallback onTakePhoto;

  const InspectorActionButtons({
    super.key,
    required this.photoCount,
    required this.onApprove,
    required this.onFlag,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TAKE PHOTO
        GestureDetector(
          onTap: onTakePhoto,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md, // 12
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textMuted.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/camera.svg",
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs), // 4/6 mapped
                Text("Take Photo ($photoCount)", style: AppStyles.bodyMedium),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        /// APPROVE + FLAG
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onApprove,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: const BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text("Approve", style: AppStyles.buttonSmall),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: GestureDetector(
                onTap: onFlag,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/flag.svg",
                        height: AppSpacing.md,
                        width: AppSpacing.md,
                        colorFilter: const ColorFilter.mode(
                          AppColors.error,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text("Flag", style: AppStyles.warningButton),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
