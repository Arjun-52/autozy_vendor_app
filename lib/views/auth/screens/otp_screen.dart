import 'package:autozy_vendor_app/views/auth/widgets/resend_otp_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../widgets/otp_box.dart';
import '../widgets/otp_header.dart';
import '../widgets/otp_logo.dart';
import '../widgets/otp_verify_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().resetVerificationState();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String getOtp() => controllers.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.horizontal20,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.custom20),

              const OtpHeader(),
              const SizedBox(height: AppSpacing.custom20),

              const OtpLogo(),
              const SizedBox(height: AppSpacing.custom20),

              const Text(
                "We have sent a verification code to",
                style: AppStyles.body16Medium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.custom5),

              Text("+91 ${vm.phoneNumber}", style: AppStyles.bold),

              const SizedBox(height: AppSpacing.custom20),

              const Text("Enter the Code", style: AppStyles.heading),

              const SizedBox(height: AppSpacing.custom20),

              /// OTP BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: AppSpacing.horizontal10,
                    child: OtpBox(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      nextFocus: index < 3 ? focusNodes[index + 1] : null,
                      prevFocus: index > 0 ? focusNodes[index - 1] : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.custom20),

              /// ERROR MESSAGE
              if (vm.errorMessage != null)
                Text(vm.errorMessage!, style: AppStyles.error),

              const SizedBox(height: AppSpacing.custom20),

              /// VERIFY BUTTON
              OtpVerifyButton(vm: vm, getOtp: getOtp),

              const SizedBox(height: AppSpacing.custom20),

              const ResendOtpText(),
            ],
          ),
        ),
      ),
    );
  }
}
