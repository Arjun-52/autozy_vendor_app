import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:autozy_vendor_app/viewmodels/auth_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/dashboard_viewmodel.dart';

class NavigationExamples {
  /// EXAMPLE 1: Basic Navigation with State Listening
  ///
  /// This pattern is used in LoginScreen:
  /// 1. UI calls ViewModel method (e.g., authViewModel.sendOtp())
  /// 2. ViewModel updates internal state (e.g., isOtpSent = true)
  /// 3. UI Consumer listens to state change
  /// 4. UI triggers navigation when state changes
  static void navigateOnStateChange(BuildContext context) {
    // Example from LoginScreen
    context.watch<AuthViewModel>(); // Listen to state changes

    // When isOtpSent becomes true, navigate
    if (context.read<AuthViewModel>().isOtpSent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/otp');
      });
    }
  }

  /// EXAMPLE 2: Navigation with User Action Confirmation
  ///
  /// This pattern is used in SelectRoleScreen:
  /// 1. User selects a role
  /// 2. UI calls ViewModel to process selection
  /// 3. On success, UI navigates immediately
  static Future<void> navigateAfterUserAction(BuildContext context) async {
    final roleViewModel = context.read<RoleViewModel>();

    // Call ViewModel method
    await roleViewModel.selectRole('Detailer');

    // Check result and navigate
    if (roleViewModel.selectedRole != null &&
        roleViewModel.errorMessage == null) {
      if (context.mounted) {
        context.go('/dashboard');
      }
    }
  }

  /// EXAMPLE 3: Navigation with Dialog Confirmation
  ///
  /// This pattern is used in Dashboard for logout:
  /// 1. Show confirmation dialog
  /// 2. On confirmation, call ViewModel logout method
  /// 3. Navigate to login screen
  static void navigateWithConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop(); // Close dialog

              // Call ViewModel method
              await context.read<DashboardViewModel>().logout();

              // Navigate to login
              if (context.mounted) {
                context.go('/');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// EXAMPLE 4: Navigation with Error Handling
  ///
  /// Shows how to handle navigation when ViewModel operations fail
  static Future<void> navigateWithErrorHandling(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();

    try {
      // Call ViewModel method
      await authViewModel.sendOtp('1234567890');

      // Check for errors before navigating
      if (authViewModel.errorMessage == null && authViewModel.isOtpSent) {
        if (context.mounted) {
          context.go('/otp');
        }
      } else {
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'Unknown error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  /// EXAMPLE 5: Navigation with Loading State
  ///
  /// Demonstrates navigation while respecting loading states
  static void navigateWithLoadingState(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    // Don't navigate if ViewModel is busy
    if (authViewModel.isLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please wait...')));
      return;
    }

    // Proceed with navigation logic
    if (authViewModel.isOtpVerified) {
      context.go('/role');
    }
  }

  /// EXAMPLE 6: Navigation Stack Management
  ///
  /// Shows different ways to manage the navigation stack
  static void demonstrateStackManagement(BuildContext context) {
    // Replace current route (most common)
    context.go('/dashboard');

    // Push new route onto stack (use sparingly)
    context.push('/settings');

    // Pop current route
    context.pop();

    // Go back to specific route
    context.go('/otp');

    // Replace entire stack with new route
    context.go('/dashboard');
  }
}

/// Extension methods for convenient navigation while maintaining MVVM
extension NavigationExtensions on BuildContext {
  /// Navigate to login screen
  void goToLogin() => go('/');

  /// Navigate to OTP screen
  void goToOtp() => go('/otp');

  /// Navigate to role selection
  void goToRole() => go('/role');

  /// Navigate to dashboard
  void goToDashboard() => go('/dashboard');

  /// Push OTP screen onto stack
  void pushOtp() => push('/otp');

  /// Push role selection onto stack
  void pushRole() => push('/role');

  /// Push dashboard onto stack
  void pushDashboard() => push('/dashboard');

  /// Navigate based on authentication state
  void navigateBasedOnAuthState() {
    final authViewModel = read<AuthViewModel>();

    if (authViewModel.isOtpVerified) {
      go('/role');
    } else if (authViewModel.isOtpSent) {
      go('/otp');
    } else {
      go('/');
    }
  }

  /// Show error message with navigation option
  void showErrorWithNavigation(String message, {String? navigationRoute}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: navigationRoute != null
            ? SnackBarAction(
                label: 'Go Back',
                onPressed: () => go(navigationRoute),
              )
            : null,
      ),
    );
  }
}

/// Widget that demonstrates reactive navigation based on ViewModel state
class ReactiveNavigator extends StatelessWidget {
  final Widget child;

  const ReactiveNavigator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
  
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        
        if (authViewModel.isOtpSent && !authViewModel.isOtpVerified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (GoRouterState.of(context).uri.path != '/otp') {
              context.go('/otp');
            }
          });
        }

        if (authViewModel.isOtpVerified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (GoRouterState.of(context).uri.path != '/role') {
              context.go('/role');
            }
          });
        }

        return Consumer<RoleViewModel>(
          builder: (context, roleViewModel, _) {
            
            if (roleViewModel.selectedRole != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (GoRouterState.of(context).uri.path != '/dashboard') {
                  context.go('/dashboard');
                }
              });
            }

            return Consumer<DashboardViewModel>(
              builder: (context, dashboardViewModel, _) {
                // Handle DashboardViewModel logout
                if (dashboardViewModel.isLoggedOut) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (GoRouterState.of(context).uri.path != '/') {
                      context.go('/');
                    }
                  });
                }

                return child;
              },
            );
          },
        );
      },
    );
  }
}

