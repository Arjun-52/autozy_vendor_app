import 'dart:core';

import 'package:autozy_vendor_app/views/detailer/widgets/capture_photo_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

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
    this.isCNA = false,
    required this.vehicle,
    required this.name,
    required this.location,
    this.isCompleted = false,
    this.index,
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
          color: isCNA
              ? Colors.white
              : isCompleted
              ? Colors.white
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isCNA ? Border.all(color: Colors.red.shade100) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: isCNA
                        ? Color(0xffD1D1D1CC)
                        : isCompleted
                        ? Color(0xffD1D1D1CC)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCNA ? Icons.directions_car : Icons.directions_car,
                    color: isCNA ? Colors.red.shade500 : Colors.black,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isCNA ? Colors.grey.shade600 : Colors.black,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: isCNA
                            ? Colors.grey.shade500
                            : const Color(0xff7E8392),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(),
                Row(
                  children: [
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),

                    if (isCompleted) const SizedBox(width: 6),

                    isCNA
                        ? const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Color(0xFF7E8392)),
                  ),
                ),
              ],
            ),

            if (!isCompleted && !isCNA) ...[
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _openCapturePhotoBottomSheet(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "Cleaned",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (index != null) {
                          context.read<DashboardViewModel>().markCNA(index!);
                        }
                      },
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "CNA",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isCompleted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (index != null) {
                      context.read<DashboardViewModel>().undoJob(index!);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.undo, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Undo",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            if (isCNA) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (index != null) {
                      context.read<DashboardViewModel>().undoCNA(index!);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.undo, size: 18, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          "Undo",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
