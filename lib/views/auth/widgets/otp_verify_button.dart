import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class OtpVerifyButton extends StatelessWidget {
  final AuthViewModel vm;
  final String Function() getOtp;

  const OtpVerifyButton({super.key, required this.vm, required this.getOtp});

  String? validateOtp(String otp) {
    if (otp.isEmpty) return "Please enter OTP";
    if (otp.length < 4) return "Enter complete OTP";
    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) return "OTP must be numeric";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: vm.isLoading
            ? null
            : () {
                final otp = getOtp(); // 👈 latest value
                final error = validateOtp(otp);

                if (error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                  return;
                }

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
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
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
