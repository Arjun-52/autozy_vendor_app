import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

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
    final bool isDisabled = seconds > 0;

    return RichText(
      text: TextSpan(
        text: "Didn't receive the OTP? ",
        style: AppStyles.bodyMedium,
        children: [
          TextSpan(
            text: isDisabled ? "Resend in $seconds s" : "Resend OTP",
            style: isDisabled ? AppStyles.linkDisabled : AppStyles.linkActive,
            recognizer: TapGestureRecognizer()
              ..onTap = isDisabled
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
