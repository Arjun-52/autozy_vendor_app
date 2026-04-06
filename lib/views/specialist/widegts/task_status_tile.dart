import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          SvgPicture.asset(
            "assets/images/user.svg",
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              highlight ? Color(0xffF6A925) : Color(0xff292D32),
              BlendMode.srcIn,
            ),
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
            style: TextStyle(
              color: Color(0xff7E8392),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
