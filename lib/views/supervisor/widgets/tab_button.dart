import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool selected;

  const TabButton({super.key, required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.amber : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
