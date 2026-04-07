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
      body: Padding(
        padding: AppSpacing.horizontal24,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.custom80),

            const LoginLogo(),

            const SizedBox(height: AppSpacing.custom40),

            const Text("Log in or Sign Up", style: AppStyles.heading),

            const SizedBox(height: AppSpacing.custom65),

            PhoneInputField(controller: _phoneController),

            const SizedBox(height: AppSpacing.lg),

            if (vm.errorMessage != null)
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),

            const SizedBox(height: AppSpacing.custom30),

            ContinueButton(
              isLoading: vm.isLoading,
              onPressed: () {
                vm.sendOtp(_phoneController.text.trim());
              },
            ),

            const SizedBox(height: AppSpacing.custom280),

            const Text(
              "By continuing, you agree to our Terms and Conditions\n& Privacy Policy",
              textAlign: TextAlign.center,
              style: AppStyles.captionCenter,
            ),

            const SizedBox(height: AppSpacing.custom20),
          ],
        ),
      ),
    );
  }
}
