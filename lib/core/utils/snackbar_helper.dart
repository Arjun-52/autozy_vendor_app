import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class SnackbarHelper {
  static void showTopNotification(BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
      ],
      messageText: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Job Completed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Job marked as Cleaned! Photo saved.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 12),
          ),
        ],
      ),
    ).show(context);
  }
}
