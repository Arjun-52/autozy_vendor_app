import 'package:flutter/material.dart';

class TaskStatusTile extends StatelessWidget {
  final String count;
  final String label;
  final bool highlight;

  const TaskStatusTile({
    super.key,
    required this.count,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 106.33333587646484,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(
            Icons.person,
            color: highlight ? Color(0xffF6A925) : Color(0xff292D32),
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: highlight ? Color(0xffF6A925) : Colors.black,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
