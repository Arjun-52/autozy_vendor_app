import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isCompleted ? 0.18 : 0.1),
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
                  color: isCompleted ? Colors.grey.shade400 : AppColors.primary,
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
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green),
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
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),

          if (!isCompleted) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 18, color: Colors.black),
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
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: const Color(0xFFD79306),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "CNA",
                          style: TextStyle(color: const Color(0xFFD79306)),
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
    );
  }
}
