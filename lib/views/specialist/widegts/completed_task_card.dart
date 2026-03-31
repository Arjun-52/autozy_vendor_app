import 'package:flutter/material.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';

class CompletedTaskCard extends StatelessWidget {
  final Task task;

  const CompletedTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('completed_${task.vehicle}'),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Car icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6E3B4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car),
          ),
          const SizedBox(width: 10),

          /// Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.vehicle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Color(0xff7E8392),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Completed in ${task.completedTime ?? 'Unknown time'}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
