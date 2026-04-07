import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/role_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../widgets/role_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

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
      context.read<AuthViewModel>().reset();
    });

    // Load roles from repository
    context.read<RoleViewModel>().loadRoles();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoleViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl),

            /// LOGO
            Column(
              children: [
                Container(
                  height: 70,
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.asset(
                      'assets/images/vendor_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                const Text("autozy", style: AppStyles.heading),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            const Text(
              "Select your role to\ncontinue",
              textAlign: TextAlign.center,
              style: AppStyles.heading,
            ),

            const SizedBox(height: AppSpacing.lg),

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

                      // ⚡ Better approach (still simple)
                      final routes = {
                        "supervisor": "/supervisor",
                        "inspector": "/inspector",
                        "specialist": "/specialist",
                      };

                      context.push(routes[roleName] ?? "/dashboard");
                    },
                  );
                },
              ),
            ),

            /// ERROR
            if (vm.errorMessage != null)
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),

            /// LOADING
            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
