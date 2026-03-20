import 'package:flutter/material.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.prevFocus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF34A853), width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            nextFocus?.requestFocus();
          } else {
            prevFocus?.requestFocus();
          }
        },
      ),
    );
  }
}
