import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OtpLogo extends StatelessWidget {
  const OtpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77,
      width: 77,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset('assets/images/vendor_logo.png', fit: BoxFit.cover),
      ),
    );
  }
}
