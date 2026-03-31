import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ResendOtpText extends StatefulWidget {
  const ResendOtpText({super.key});

  @override
  State<ResendOtpText> createState() => _ResendOtpTextState();
}

class _ResendOtpTextState extends State<ResendOtpText> {
  int seconds = 0;
  Timer? timer;

  void startTimer() {
    setState(() {
      seconds = 30;
    });

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Didn't receive the OTP? ",
        style: const TextStyle(
          color: Color(0xff5B5B5E),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: seconds > 0 ? "Resend in $seconds s" : "Resend OTP",
            style: TextStyle(
              color: seconds > 0 ? Colors.grey : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = seconds > 0
                  ? null
                  : () {
                      startTimer();
                    },
          ),
        ],
      ),
    );
  }
}
