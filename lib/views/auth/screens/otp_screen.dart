import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // Reset AuthViewModel verification state when OTP screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AuthViewModel>();
      vm.resetVerificationState();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 60),

            const OtpHeader(),

            const SizedBox(height: 20),

            const OtpLogo(),

            const SizedBox(height: 20),

            const Text(
              "We have sent a verification code to",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            Text(
              "+91 ${vm.phoneNumber}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Enter the Code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // OTP BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OtpBox(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    nextFocus: index < 3 ? focusNodes[index + 1] : null,
                    prevFocus: index > 0 ? focusNodes[index - 1] : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (vm.errorMessage != null)
              Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            OtpVerifyButton(vm: vm, getOtp: getOtp),

            const SizedBox(height: 20),

            const Text.rich(
              TextSpan(
                text: "Didn't receive the OTP? ",
                children: [
                  TextSpan(
                    text: "Resend OTP",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
