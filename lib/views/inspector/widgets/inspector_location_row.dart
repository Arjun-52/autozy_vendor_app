import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InspectorLocationRow extends StatelessWidget {
  final String location;

  const InspectorLocationRow({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    if (location.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
