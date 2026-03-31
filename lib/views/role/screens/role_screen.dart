import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/role_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../widgets/role_card.dart';
import '../../../core/constants/app_colors.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = context.read<AuthViewModel>();
      authVm.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoleViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Logo
            Column(
              children: [
                Container(
                  height: 69,
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/vendor_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "autozy",
                  style: TextStyle(
                    fontSize: 24.46,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Select your role to\ncontinue",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: vm.roles.length,
                itemBuilder: (context, index) {
                  final role = vm.roles[index];

                  return RoleCard(
                    role: role,
                    onTap: () {
                      vm.selectRole(role.title);

                      final roleName = role.title.trim().toLowerCase();

                      if (roleName == "supervisor") {
                        context.go('/supervisor');
                      } else if (roleName == "inspector") {
                        context.go('/inspector');
                      } else if (roleName == "specialist") {
                        context.go('/specialist');
                      } else {
                        context.go('/dashboard');
                      }
                    },
                  );
                },
              ),
            ),

            // Error
            if (vm.errorMessage != null)
              Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),

            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
