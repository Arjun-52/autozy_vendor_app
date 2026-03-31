import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff7E8392),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
