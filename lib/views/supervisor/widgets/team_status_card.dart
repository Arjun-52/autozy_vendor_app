import 'package:flutter/material.dart';

class TeamStatusCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color color;

  const TeamStatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 106.33,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withValues(alpha: 0.12),
            blurRadius: 13,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          icon,
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            subtitle,
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
