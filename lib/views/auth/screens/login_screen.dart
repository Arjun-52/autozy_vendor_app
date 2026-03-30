import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: const Color(0xFFF3F2F0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 80),

            const LoginLogo(),

            const SizedBox(height: 40),

            const Text(
              "Log in or Sign Up",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 65),

            PhoneInputField(controller: _phoneController),

            const SizedBox(height: 16),

            if (vm.errorMessage != null)
              Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 30),

            ContinueButton(
              isLoading: vm.isLoading,
              onPressed: () {
                vm.sendOtp(_phoneController.text.trim());
              },
            ),

            const SizedBox(height: 280),

            const Text(
              "By continuing, you agree to our Terms and Conditions\n& Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
