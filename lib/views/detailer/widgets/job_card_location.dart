import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class JobCardLocation extends StatelessWidget {
  final String location;

  const JobCardLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}
