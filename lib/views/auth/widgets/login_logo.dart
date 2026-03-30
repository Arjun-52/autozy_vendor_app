import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 69,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/vendor_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "autozy",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: AppColors.title,
          ),
        ),
        const Text(
          "Service",
          style: TextStyle(fontSize: 14, color: AppColors.shadeYellow),
        ),
      ],
    );
  }
}
