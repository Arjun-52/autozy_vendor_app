import 'package:autozy_vendor_app/views/dashboard/widgets/capture_photo_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'job_details_bottom_sheet.dart';

class JobCard extends StatelessWidget {
  final String vehicle;
  final String name;
  final String location;
  final bool isCompleted;

  const JobCard({
    super.key,
    required this.vehicle,
    required this.name,
    required this.location,
    this.isCompleted = false,
  });

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JobDetailsBottomSheet(
        vehicle: vehicle,
        name: name,
        location: location,
        phone: "9145679913",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBottomSheet(context),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isCompleted ? 0.18 : 0.1),
              blurRadius: isCompleted ? 16 : 10,
              spreadRadius: isCompleted ? 2 : 0,
              offset: const Offset(0, 6),
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
                    color: isCompleted
                        ? Colors.grey.shade400
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.directions_car),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(name, style: const TextStyle(color: Colors.black)),
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),

                    if (isCompleted) const SizedBox(width: 6),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
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

            if (!isCompleted) ...[
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const CapturePhotoBottomSheet(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Cleaned",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: Color(0xFFD79306),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "CNA",
                            style: TextStyle(color: Color(0xFFD79306)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
