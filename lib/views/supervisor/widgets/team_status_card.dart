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

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withOpacity(0.12),
            blurRadius: 13,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
