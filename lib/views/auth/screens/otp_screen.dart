import 'package:autozy_vendor_app/views/auth/widgets/resend_otp_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppSpacing.horizontal20,
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.custom20),
                        const OtpHeader(),
                        const Spacer(flex: 2),
                        const OtpLogo(),
                        const Spacer(flex: 1),
                        const Text(
                          "We have sent a verification code to",
                          style: AppStyles.body16Medium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.custom5),
                        Text("+91 ${vm.phoneNumber}", style: AppStyles.bold),
                        const Spacer(flex: 2),
                        const Text("Enter the Code", style: AppStyles.heading),
                        const SizedBox(height: AppSpacing.custom20),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                6,
                                (index) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: OtpBox(
                                      controller: controllers[index],
                                      focusNode: focusNodes[index],
                                      nextFocus: index < 5 ? focusNodes[index + 1] : null,
                                      prevFocus: index > 0 ? focusNodes[index - 1] : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (vm.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.custom10),
                          Text(vm.errorMessage!, style: AppStyles.error),
                        ],
                        const SizedBox(height: 20),
                        const ResendOtpText(),
                        const Spacer(flex: 3),
                        OtpVerifyButton(vm: vm, getOtp: getOtp),
                        const SizedBox(height: AppSpacing.custom20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

