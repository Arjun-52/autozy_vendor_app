import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../viewmodels/auth_viewmodel.dart';
import '../widgets/login_logo.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/continue_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
                    padding: AppSpacing.horizontal24,
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        const LoginLogo(),
                        const SizedBox(height: AppSpacing.custom40),
                        const Text("Log in or Sign Up", style: AppStyles.heading),
                        const SizedBox(height: AppSpacing.custom40),
                        PhoneInputField(controller: _phoneController),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.errorMessage != null)
                          Text(
                            vm.errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        const SizedBox(height: AppSpacing.custom20),
                        ContinueButton(
                          isLoading: vm.isLoading,
                          onPressed: () async {
                            await vm.sendOtp(_phoneController.text.trim());
                            if (mounted && vm.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(vm.errorMessage!),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          },
                        ),
                        const Spacer(flex: 4),
                        const Text(
                          "By continuing, you agree to our Terms and Conditions\n& Privacy Policy",
                          textAlign: TextAlign.center,
                          style: AppStyles.captionCenter,
                        ),
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
