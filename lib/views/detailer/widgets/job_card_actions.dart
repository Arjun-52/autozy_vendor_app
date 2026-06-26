import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../data/models/job_model.dart';

class JobCardActions extends StatelessWidget {
  final JobStatus status;
  final int? index;
  final VoidCallback onClean;
  final VoidCallback? onTapCard;

  const JobCardActions({
    super.key,
    required this.status,
    required this.index,
    required this.onClean,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DashboardViewModel>();
    final isCompleted = status == JobStatus.completed;
    final isCNA = status == JobStatus.cna;

    if (kDebugMode) {
      print(
        'Widget rendering status: ${status.logLabel} | index: $index '
        '| state: ${isCompleted ? 'COMPLETED' : isCNA ? 'CNA' : status.logLabel}',
      );
    }

    if (status == JobStatus.pending && !isCNA) {
      return Row(
        children: [
          Expanded(
            child: _PrimaryButton(
              text: "Start Job",
              icon: "assets/images/camera.svg",
              onTap: onTapCard ?? () {},
            ),
          ),
          const SizedBox(width: AppSpacing.custom10),
          Expanded(
            child: _OutlineButton(
              text: "CNA",
              icon: "assets/images/disclaimer.svg",
              onTap: () {
                if (index != null) vm.markCNA(index!);
              },
            ),
          ),
        ],
      );
    }

    if (status == JobStatus.cleaning && !isCNA) {
      return Row(
        children: [
          Expanded(
            child: _PrimaryButton(
              text: "Cleaned",
              icon: "assets/images/camera.svg",
              onTap: onClean,
            ),
          ),
          const SizedBox(width: AppSpacing.custom10),
          Expanded(
            child: _OutlineButton(
              text: "CNA",
              icon: "assets/images/disclaimer.svg",
              onTap: () {
                if (index != null) vm.markCNA(index!);
              },
            ),
          ),
        ],
      );
    }

    if (isCompleted) {
      return _UndoButton(
        onTap: () {
          if (index != null) vm.undoJob(index!);
        },
      );
    }

    if (isCNA) {
      return _UndoButton(
        isWarning: true,
        onTap: () {
          if (index != null) vm.undoCNA(index!);
        },
      );
    }

    return const SizedBox();
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius14),
      child: Container(
        padding: AppSpacing.vertical10,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radius14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.custom6),
            Text(text, style: AppStyles.buttonSmall),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius14),
      child: Container(
        padding: AppSpacing.vertical10,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppSpacing.radius14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: const ColorFilter.mode(
                AppColors.warning,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.custom6),
            Text(text, style: AppStyles.warningButton),
          ],
        ),
      ),
    );
  }
}

class _UndoButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isWarning;

  const _UndoButton({required this.onTap, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: AppSpacing.vertical10,
        decoration: BoxDecoration(
          color: isWarning ? AppColors.warningLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/undo.svg",
              height: AppSpacing.md,
              width: AppSpacing.md,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.custom6),
            const Text("Undo", style: AppStyles.buttonSmall),
          ],
        ),
      ),
    );
  }
}
