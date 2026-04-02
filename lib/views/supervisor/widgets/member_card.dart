import "package:autozy_vendor_app/data/models/team_member.dart";
import "package:autozy_vendor_app/views/supervisor/widgets/action_button.dart";
import "package:autozy_vendor_app/views/supervisor/widgets/progress_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "../../../core/constants/app_colors.dart";
import "../../../core/constants/app_spacing.dart";
import "../../../core/constants/app_styles.dart";

class MemberCard extends StatelessWidget {
  final TeamMember member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    double progress = member.completed / member.total;

    final isActive = member.status == "Active";

    Color statusColor = isActive ? AppColors.successDark : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          /// HEADER ROW
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: SvgPicture.asset(
                    "assets/images/profile-tick.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppStyles.bodyMedium),

                  Row(
                    children: [
                      Text(member.role, style: AppStyles.caption),

                      const SizedBox(width: AppSpacing.xs),

                      Container(
                        width: AppSpacing.xs,
                        height: AppSpacing.xs,
                        decoration: const BoxDecoration(
                          color: AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: AppSpacing.xs),

                      Text(member.tower, style: AppStyles.caption),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  color: statusColor.withOpacity(0.1),
                  border: Border.all(color: statusColor.withOpacity(0.8)),
                ),
                child: Text(
                  member.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          /// PROGRESS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress: ${member.completed}/${member.total}",
                style: AppStyles.caption,
              ),
              SizedBox(width: 120, child: ProgressBar(value: progress)),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          /// ACTIONS
          Row(
            children: [
              ActionButton(
                icon: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: SvgPicture.asset(
                    "assets/images/call.svg",
                    height: AppSpacing.lg,
                    width: AppSpacing.lg,
                    fit: BoxFit.contain,
                  ),
                ),
                text: "Call",
              ),

              const SizedBox(width: AppSpacing.sm),

              ActionButton(
                icon: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: SvgPicture.asset(
                    "assets/images/workFlow.svg",
                    height: AppSpacing.lg,
                    width: AppSpacing.lg,
                    fit: BoxFit.contain,
                  ),
                ),
                text: "Reassign",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
