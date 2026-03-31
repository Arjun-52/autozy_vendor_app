import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class OtpVerifyButton extends StatelessWidget {
  final AuthViewModel vm;
  final String Function() getOtp;

  const OtpVerifyButton({super.key, required this.vm, required this.getOtp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: vm.isLoading
            ? null
            : () {
                final otp = getOtp();
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
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
