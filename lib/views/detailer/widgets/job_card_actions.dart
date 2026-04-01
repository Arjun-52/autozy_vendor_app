import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class JobCardActions extends StatelessWidget {
  final bool isCompleted;
  final bool isCNA;
  final int? index;
  final VoidCallback onClean;

  const JobCardActions({
    super.key,
    required this.isCompleted,
    required this.isCNA,
    required this.index,
    required this.onClean,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DashboardViewModel>();

    if (!isCompleted && !isCNA) {
      return Row(
        children: [
          Expanded(
            child: _PrimaryButton(
              text: "Cleaned",
              icon: "assets/images/camera.svg",
              onTap: onClean,
            ),
          ),
          const SizedBox(width: 10),
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
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
            const SizedBox(width: 6),
            const Text(
              "Cleaned",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
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
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(13),
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
            const SizedBox(width: 6),
            const Text(
              "CNA",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isWarning ? Colors.amber.shade200 : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/undo.svg",
              height: 16,
              width: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              "Undo",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
