import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';

/// SelectRoleScreen - Role selection screen
/// 
/// MVVM Architecture Example:
/// - Listens to RoleViewModel.selectedRole state
/// - When a role is selected and confirmed, navigates to '/dashboard'
/// - Navigation is triggered from UI based on ViewModel state change
class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to OTP screen
            context.go('/otp');
          },
        ),
      ),
      body: Consumer<RoleViewModel>(
        builder: (context, roleViewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Text(
                  'Choose Your Role',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select the role that best describes your position',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Error Message
                if (roleViewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            roleViewModel.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => roleViewModel.clearError(),
                        ),
                      ],
                    ),
                  ),

                if (roleViewModel.errorMessage != null)
                  const SizedBox(height: 20),

                // Role Selection Cards
                Expanded(
                  child: ListView.builder(
                    itemCount: roleViewModel.roles.length,
                    itemBuilder: (context, index) {
                      final role = roleViewModel.roles[index];
                      final isSelected = roleViewModel.selectedRole == role;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GestureDetector(
                          onTap: roleViewModel.isLoading
                              ? null
                              : () async {
                                  // Call ViewModel to select role
                                  await roleViewModel.selectRole(role);

                                  // IMPORTANT: Listen to selectedRole state
                                  // If role was selected successfully, navigate
                                  if (roleViewModel.selectedRole == role &&
                                      roleViewModel.errorMessage == null) {
                                    if (context.mounted) {
                                      context.go('/dashboard');
                                    }
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? Colors.blue.shade50
                                  : Colors.white,
                            ),
                            child: Row(
                              children: [
                                // Role Icon
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade200,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getRoleIcon(role),
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Role Name and Description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getRoleDescription(role),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkmark for selected role
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Button
                ElevatedButton(
                  onPressed: roleViewModel.selectedRole == null ||
                          roleViewModel.isLoading
                      ? null
                      : () async {
                          // Role is already selected, just navigate
                          context.go('/dashboard');
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: roleViewModel.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Get appropriate icon for each role
  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Detailer':
        return Icons.car_repair;
      case 'Manager':
        return Icons.supervisor_account;
      case 'Admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  /// Get role description
  String _getRoleDescription(String role) {
    switch (role) {
      case 'Detailer':
        return 'Manage car detailing services';
      case 'Manager':
        return 'Oversee team and operations';
      case 'Admin':
        return 'Full system administration';
      default:
        return '';
    }
  }
}
