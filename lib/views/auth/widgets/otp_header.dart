import 'package:flutter/material.dart';
import '../../../core/services/navigation_service.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => NavigationService.goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          "OTP Verification",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
