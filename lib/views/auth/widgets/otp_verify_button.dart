import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class OtpVerifyButton extends StatelessWidget {
  final AuthViewModel vm;
  final String otp;

  const OtpVerifyButton({super.key, required this.vm, required this.otp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: vm.isLoading
            ? null
            : () {
                vm.verifyOtp(otp);
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: vm.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Verify & Continue",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
