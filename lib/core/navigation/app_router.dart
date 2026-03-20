import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:autozy_vendor_app/views/auth/login_screen.dart';
import 'package:autozy_vendor_app/views/auth/otp_screen.dart';
import 'package:autozy_vendor_app/views/role/select_role_screen.dart';
import 'package:autozy_vendor_app/views/dashboard/detailer_dashboard.dart';

/// App router configuration using GoRouter
///
/// This router follows MVVM architecture principles:
/// - Routes are defined centrally in one place
/// - Navigation is triggered only from the UI layer
/// - ViewModels expose state but don't handle navigation
/// - UI listens to ViewModel state and triggers navigation accordingly
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// Defines all available routes in the application
  static final GoRouter router = GoRouter(
    // Initial route when the app starts
    initialLocation: '/',

    // Error handling for unknown routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),

    // Define all routes
    routes: [
      // Login screen - Entry point of the app
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // OTP verification screen
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),

      // Role selection screen
      GoRoute(
        path: '/role',
        name: 'role',
        builder: (context, state) => const SelectRoleScreen(),
      ),

      // Dashboard screen
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DetailerDashboard(),
      ),
    ],
  );
}

/// Extension on BuildContext to provide convenient navigation methods
/// This makes it easy to navigate from the UI layer while maintaining type safety
extension GoRouterExtension on GoRouter {
  /// Navigate to login screen (replaces all previous routes)
  void goToLogin() => go('/');

  /// Navigate to OTP screen (replaces current route)
  void goToOtp() => go('/otp');

  /// Navigate to role selection (replaces current route)
  void goToRole() => go('/role');

  /// Navigate to dashboard (replaces current route)
  void goToDashboard() => go('/dashboard');

  /// Push login screen onto the stack (use only if stacking is needed)
  void pushLogin() => push('/');

  /// Push OTP screen onto the stack
  void pushOtp() => push('/otp');

  /// Push role selection screen onto the stack
  void pushRole() => push('/role');

  /// Push dashboard onto the stack
  void pushDashboard() => push('/dashboard');
}
