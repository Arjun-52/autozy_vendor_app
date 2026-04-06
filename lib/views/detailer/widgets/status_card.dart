import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 77.75,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconColor != null
              ? IconTheme(
                  data: IconThemeData(color: iconColor),
                  child: icon,
                )
              : icon,
          const SizedBox(height: 6),

          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff7E8392), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
