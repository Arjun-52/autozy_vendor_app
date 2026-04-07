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
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF636363).withValues(alpha: 0.16),
                  blurRadius: 8,
                  spreadRadius: 0,
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
                const SizedBox(width: AppSpacing.xs),
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
                  height: 40,
                  width: 145.5,

                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/flag.svg",
                        height: 16,
                        width: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.error,
                          BlendMode.srcIn,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Flag",
                        style: TextStyle(
                          color: Color(0xffFF383C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
